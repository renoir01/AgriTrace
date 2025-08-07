# AgriTrace Monitoring Setup

This document outlines the monitoring configuration for the AgriTrace application, including Azure Monitor integration, health check endpoints, and alert configuration.

## Azure Monitor Integration

AgriTrace uses Azure Monitor for application monitoring and alerting. The integration is implemented through the following components:

1. **OpenCensus Middleware**: Integrated with Django to track requests and send telemetry data to Azure Monitor.
2. **Structured JSON Logging**: All application logs are formatted as JSON for better parsing and analysis.
3. **Health Check Endpoints**: Dedicated endpoints for monitoring application health and readiness.

## Health Check Endpoints

The following health check endpoints are available for monitoring:

- `/api/health/`: Basic health check that returns 200 OK if the application is running.
- `/api/ready/`: Readiness check that verifies database connectivity.
- `/api/live/`: Liveness check for container orchestration systems.

These endpoints are used by Azure Monitor to track application availability and performance.

## Azure Monitor Dashboard Setup

To set up the Azure Monitor dashboard for AgriTrace:

1. Log in to the Azure Portal.
2. Navigate to Azure Monitor > Dashboards.
3. Click "New Dashboard" and select "Custom".
4. Add the following widgets:
   - Application Insights metrics for request rate and response time
   - Log Analytics query for error rates
   - Health check status monitor
   - Database performance metrics

## Alert Configuration

The following alerts are configured in Azure Monitor:

### 1. High CPU Usage Alert

This alert triggers when the CPU usage exceeds 80% for more than 5 minutes.

**Configuration:**
- Metric: `CPU Percentage`
- Threshold: 80%
- Evaluation period: 5 minutes
- Frequency: 1 minute
- Severity: 2 (Warning)
- Action: Email notification to the operations team

### 2. Error Rate Alert

This alert triggers when the application error rate exceeds 5% of total requests.

**Configuration:**
- Query: `requests | where success == false | summarize ErrorCount=count() by bin(timestamp, 5m)`
- Threshold: Count > 5% of total requests
- Evaluation period: 15 minutes
- Frequency: 5 minutes
- Severity: 1 (Critical)
- Action: Email notification and SMS to on-call engineer

### 3. Database Connection Failure Alert

This alert triggers when the application fails to connect to the database.

**Configuration:**
- Based on health check endpoint `/api/ready/`
- Threshold: Status code != 200
- Evaluation period: 1 minute
- Frequency: 1 minute
- Severity: 0 (Critical)
- Action: Email notification, SMS, and PagerDuty integration

## Environment Variables

The following environment variables must be set for Azure Monitor integration:

```
APPLICATIONINSIGHTS_CONNECTION_STRING=<your-connection-string>
```

This connection string is available in the Azure Portal under Application Insights > API Access.

## Monitoring Dashboard Access

The monitoring dashboard is available to authorized users at:

```
https://portal.azure.com/#@<tenant-id>/dashboard/arm/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Portal/dashboards/AgriTraceDashboard
```

## Logging Configuration

The application uses structured JSON logging with the following configuration:

- All logs are formatted as JSON using `python-json-logger`.
- Logs are separated by concern (API, security, database, etc.).
- Log rotation is configured to prevent disk space issues.
- Production logs are stored in `/app/logs/` with appropriate permissions.

For more details on the logging configuration, see the `settings.py` file in the Django project.
