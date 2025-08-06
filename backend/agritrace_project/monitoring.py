"""
Azure Monitor integration for AgriTrace application.
This module provides middleware and utilities for monitoring the application using Azure Monitor.
"""

import logging
import sys
import time
import os
from opencensus.ext.azure.log_exporter import AzureLogHandler
from opencensus.ext.azure.trace_exporter import AzureExporter
from opencensus.ext.django.middleware import OpencensusMiddleware
from opencensus.trace.samplers import ProbabilitySampler
from opencensus.trace import config_integration

# Configure OpenCensus to trace Django requests
config_integration.trace_integrations(['django'])

logger = logging.getLogger(__name__)

class AzureMonitorMiddleware:
    """
    Middleware to track request performance and send metrics to Azure Monitor.
    """
    def __init__(self, get_response):
        self.get_response = get_response
        self.logger = logging.getLogger('agritrace_project.monitoring')
        
        # Check if we're in a test environment
        self.testing = 'test' in sys.argv or os.environ.get('DJANGO_SETTINGS_MODULE') == 'agritrace_project.test_settings'
        
        # Set up Azure Monitor if connection string is available and not in test mode
        self.app_insights_key = os.environ.get('APPLICATIONINSIGHTS_CONNECTION_STRING')
        if self.app_insights_key and not self.testing:
            # Add Azure Log Handler to the root logger
            azure_handler = AzureLogHandler(connection_string=self.app_insights_key)
            logging.getLogger('').addHandler(azure_handler)
            
            self.logger.info("Azure Monitor integration enabled")
        else:
            if self.testing:
                self.logger.info("Test environment detected, Azure Monitor disabled")
            else:
                self.logger.warning("Azure Monitor connection string not found, monitoring disabled")

    def __call__(self, request):
        start_time = time.time()
        
        # Process the request
        response = self.get_response(request)
        
        # Calculate request duration
        duration = time.time() - start_time
        
        # Log request metrics
        self.logger.info(
            'Request processed',
            extra={
                'custom_dimensions': {
                    'path': request.path,
                    'method': request.method,
                    'status_code': response.status_code,
                    'duration_ms': int(duration * 1000),
                    'user_agent': request.META.get('HTTP_USER_AGENT', 'Unknown'),
                }
            }
        )
        
        # Track slow requests (over 1 second)
        if duration > 1:
            self.logger.warning(
                'Slow request detected',
                extra={
                    'custom_dimensions': {
                        'path': request.path,
                        'method': request.method,
                        'duration_ms': int(duration * 1000),
                    }
                }
            )
        
        return response


class HealthCheckMiddleware:
    """
    Middleware to track health check metrics separately from regular requests.
    """
    def __init__(self, get_response):
        self.get_response = get_response
        self.logger = logging.getLogger('agritrace_project.health')
        self.health_endpoints = ['/api/health/', '/api/ready/', '/api/live/']

    def __call__(self, request):
        if request.path in self.health_endpoints:
            start_time = time.time()
            response = self.get_response(request)
            duration = time.time() - start_time
            
            status = 'healthy' if response.status_code == 200 else 'unhealthy'
            
            self.logger.info(
                f'Health check: {status}',
                extra={
                    'custom_dimensions': {
                        'endpoint': request.path,
                        'status': status,
                        'duration_ms': int(duration * 1000),
                    }
                }
            )
            
            return response
        
        return self.get_response(request)


def setup_azure_monitoring():
    """
    Configure Azure Monitor integration if the connection string is available.
    """
    app_insights_key = os.environ.get('APPLICATIONINSIGHTS_CONNECTION_STRING')
    
    if not app_insights_key:
        logger.warning("Azure Monitor connection string not found, monitoring not configured")
        return False
    
    # Set up Azure Monitor exporter
    azure_exporter = AzureExporter(
        connection_string=app_insights_key,
        service_name='AgriTrace',
    )
    
    # Configure sampling rate (adjust as needed)
    sampler = ProbabilitySampler(rate=1.0)  # 100% sampling
    
    logger.info("Azure Monitor integration configured successfully")
    return True
