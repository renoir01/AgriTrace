"""
Health check views for AgriTrace backend monitoring
"""
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.db import connection
from django.conf import settings
import json
import logging
import time

logger = logging.getLogger(__name__)

@csrf_exempt
@require_http_methods(["GET"])
def health_check(request):
    """
    Comprehensive health check endpoint for monitoring
    Returns system status, database connectivity, and performance metrics
    """
    start_time = time.time()
    health_status = {
        "status": "healthy",
        "timestamp": time.time(),
        "version": "1.0.0",
        "environment": getattr(settings, 'ENVIRONMENT', 'development'),
        "checks": {}
    }
    
    # Database connectivity check
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            health_status["checks"]["database"] = {
                "status": "healthy",
                "message": "Database connection successful"
            }
    except Exception as e:
        health_status["status"] = "unhealthy"
        health_status["checks"]["database"] = {
            "status": "unhealthy",
            "message": f"Database connection failed: {str(e)}"
        }
        logger.error(f"Health check database error: {e}")
    
    # Application performance metrics
    response_time = (time.time() - start_time) * 1000  # Convert to milliseconds
    health_status["checks"]["performance"] = {
        "status": "healthy" if response_time < 1000 else "degraded",
        "response_time_ms": round(response_time, 2)
    }
    
    # Memory usage check (basic)
    import psutil
    try:
        memory_percent = psutil.virtual_memory().percent
        health_status["checks"]["memory"] = {
            "status": "healthy" if memory_percent < 80 else "warning",
            "usage_percent": memory_percent
        }
    except Exception as e:
        health_status["checks"]["memory"] = {
            "status": "unknown",
            "message": f"Memory check failed: {str(e)}"
        }
    
    # Set overall status based on critical checks
    if health_status["checks"]["database"]["status"] == "unhealthy":
        health_status["status"] = "unhealthy"
    elif any(check["status"] in ["warning", "degraded"] for check in health_status["checks"].values()):
        health_status["status"] = "degraded"
    
    # Log health check results
    logger.info(f"Health check completed: {health_status['status']}")
    
    status_code = 200 if health_status["status"] == "healthy" else 503
    return JsonResponse(health_status, status=status_code)

@csrf_exempt
@require_http_methods(["GET"])
def readiness_check(request):
    """
    Readiness probe for Kubernetes/container orchestration
    """
    try:
        # Check if application is ready to serve traffic
        with connection.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) FROM django_migrations")
            migration_count = cursor.fetchone()[0]
            
        if migration_count > 0:
            return JsonResponse({"status": "ready", "migrations": migration_count})
        else:
            return JsonResponse({"status": "not_ready", "message": "No migrations found"}, status=503)
    except Exception as e:
        logger.error(f"Readiness check failed: {e}")
        return JsonResponse({"status": "not_ready", "error": str(e)}, status=503)

@csrf_exempt
@require_http_methods(["GET"])
def liveness_check(request):
    """
    Liveness probe for Kubernetes/container orchestration
    """
    return JsonResponse({"status": "alive", "timestamp": time.time()})
