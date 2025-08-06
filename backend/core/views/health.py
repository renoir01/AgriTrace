"""
Health check views for monitoring the application.
These endpoints are used by monitoring systems to check the health and readiness of the application.
"""

import logging
import time
from django.db import connections
from django.db.utils import OperationalError
from django.http import JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny

logger = logging.getLogger('core.api')

@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    """
    Basic health check endpoint.
    Returns 200 OK if the application is running.
    """
    logger.info("Health check endpoint called")
    return JsonResponse({
        'status': 'healthy',
        'service': 'AgriTrace API',
        'timestamp': time.time()
    })

@api_view(['GET'])
@permission_classes([AllowAny])
def readiness_check(request):
    """
    Readiness check endpoint.
    Checks if the application can connect to the database.
    Returns 200 OK if ready, 503 Service Unavailable if not.
    """
    start_time = time.time()
    try:
        # Check database connection
        db_conn = connections['default']
        db_conn.cursor()
        db_status = True
    except OperationalError:
        db_status = False
    
    duration = time.time() - start_time
    
    status = 'ready' if db_status else 'not_ready'
    status_code = 200 if db_status else 503
    
    logger.info(f"Readiness check: {status}", extra={
        'custom_dimensions': {
            'database_status': db_status,
            'response_time_ms': int(duration * 1000)
        }
    })
    
    response = JsonResponse({
        'status': status,
        'database': 'connected' if db_status else 'disconnected',
        'timestamp': time.time()
    })
    response.status_code = status_code
    return response

@api_view(['GET'])
@permission_classes([AllowAny])
def liveness_check(request):
    """
    Liveness check endpoint.
    Checks if the application is alive and can process requests.
    Returns 200 OK if alive, 500 Internal Server Error if not.
    """
    # This is a simple check that the application can process requests
    # In a real-world scenario, you might want to check other dependencies
    
    logger.info("Liveness check endpoint called")
    return JsonResponse({
        'status': 'alive',
        'service': 'AgriTrace API',
        'timestamp': time.time()
    })
