#!/usr/bin/env python
"""
AgriTrace Endpoint Verification Script
This script checks the health and accessibility of AgriTrace public endpoints
and generates a comprehensive report on deployment status.

Usage: python verify_endpoints.py [prod|staging] [--json] [--markdown]
"""

import sys
import json
import requests
import argparse
from datetime import datetime
from urllib3.exceptions import InsecureRequestWarning

# Suppress only the single warning from urllib3 needed.
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

# Define ANSI color codes for terminal output
COLORS = {
    'GREEN': '\033[92m',
    'YELLOW': '\033[93m',
    'RED': '\033[91m',
    'RESET': '\033[0m',
    'BOLD': '\033[1m'
}

def check_endpoint(url, name, expected_status=200, check_response_time=True, check_content=None):
    """Check if an endpoint is accessible and returns the expected status code"""
    print(f"Checking {name}... ", end="")
    result = {
        'name': name,
        'url': url,
        'expected_status': expected_status,
        'success': False,
        'status_code': None,
        'response_time_ms': None,
        'error': None,
        'content_check': None
    }
    
    try:
        start_time = datetime.now()
        response = requests.get(url, timeout=10, verify=False)
        end_time = datetime.now()
        response_time = (end_time - start_time).total_seconds() * 1000  # Convert to milliseconds
        status_code = response.status_code
        
        result['status_code'] = status_code
        result['response_time_ms'] = round(response_time, 2)
        
        # Check status code
        status_match = status_code == expected_status
        
        # Check content if specified
        content_match = True
        if check_content and status_match:
            content_match = check_content in response.text
            result['content_check'] = content_match
        
        result['success'] = status_match and content_match
        
        if result['success']:
            print(f"{COLORS['GREEN']}OK{COLORS['RESET']} ({status_code}, {round(response_time, 2)}ms)")
        else:
            if not status_match:
                print(f"{COLORS['RED']}FAILED{COLORS['RESET']} (Got {status_code}, expected {expected_status})")
            else:
                print(f"{COLORS['RED']}FAILED{COLORS['RESET']} (Content check failed)")
    except Exception as e:
        print(f"{COLORS['RED']}ERROR{COLORS['RESET']}: {str(e)}")
        result['error'] = str(e)
    
    return result

def generate_markdown_report(results, env_name, frontend_url, api_url):
    """Generate a markdown report from the verification results"""
    report = f"# AgriTrace {env_name} Deployment Verification Report\n\n"
    report += f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
    
    report += "## Environment Details\n\n"
    report += f"- **Environment:** {env_name}\n"
    report += f"- **Frontend URL:** {frontend_url}\n"
    report += f"- **API URL:** {api_url}\n\n"
    
    report += "## Endpoint Status Summary\n\n"
    report += "| Endpoint | Status | Response Time | Notes |\n"
    report += "|---------|--------|--------------|-------|\n"
    
    for result in results:
        status = "✅ Success" if result['success'] else "❌ Failed"
        notes = ""
        if not result['success']:
            if result['error']:
                notes = f"Error: {result['error']}"
            elif result['status_code'] is not None:
                notes = f"Expected {result['expected_status']}, got {result['status_code']}"
            elif result['content_check'] is False:
                notes = "Content check failed"
        
        report += f"| {result['name']} | {status} | {result['response_time_ms']}ms | {notes} |\n"
    
    # Calculate success rate
    success_count = sum(1 for r in results if r['success'])
    total_count = len(results)
    success_rate = (success_count / total_count) * 100 if total_count > 0 else 0
    
    report += f"\n## Summary\n\n"
    report += f"- **Total Endpoints Checked:** {total_count}\n"
    report += f"- **Successful:** {success_count}\n"
    report += f"- **Failed:** {total_count - success_count}\n"
    report += f"- **Success Rate:** {success_rate:.1f}%\n"
    
    return report

def main():
    """Main function to verify endpoints"""
    parser = argparse.ArgumentParser(description='Verify AgriTrace endpoints')
    parser.add_argument('environment', choices=['prod', 'production', 'staging', 'dev'], 
                        help='Environment to check (prod/production or staging/dev)')
    parser.add_argument('--json', action='store_true', help='Output results as JSON')
    parser.add_argument('--markdown', action='store_true', help='Generate markdown report')
    parser.add_argument('--output', help='Output file for report')
    
    args = parser.parse_args()
    env = args.environment.lower()
    
    if env in ["prod", "production"]:
        env_name = "Production"
        frontend_url = "https://agritrace-prod.eastus.azurecontainer.io"
        api_url = "https://agritrace-api.eastus.azurecontainer.io:8000"
    elif env in ["staging", "dev"]:
        env_name = "Staging"
        frontend_url = "https://agritrace-staging.eastus.azurecontainer.io"
        api_url = "https://agritrace-staging-api.eastus.azurecontainer.io:8000"
    else:
        print(f"Invalid environment: {env}")
        sys.exit(1)
    
    if not args.json:
        print(f"{COLORS['BOLD']}AgriTrace {env_name} Deployment Verification{COLORS['RESET']}")
        print("=" * 40)
        print(f"Timestamp: {datetime.now()}")
        print("")
    
    results = []
    
    # Check frontend endpoints
    if not args.json:
        print(f"\n{COLORS['BOLD']}Frontend Checks:{COLORS['RESET']}")
    
    results.append(check_endpoint(frontend_url, "Frontend main page", check_content="AgriTrace"))
    results.append(check_endpoint(f"{frontend_url}/health", "Frontend health endpoint", check_content="status"))
    results.append(check_endpoint(f"{frontend_url}/static/js/main.js", "Frontend static assets"))
    
    # Check backend API endpoints
    if not args.json:
        print(f"\n{COLORS['BOLD']}Backend API Checks:{COLORS['RESET']}")
    
    results.append(check_endpoint(f"{api_url}/api/health/", "API health endpoint", check_content="healthy"))
    results.append(check_endpoint(f"{api_url}/api/ready/", "API readiness probe"))
    results.append(check_endpoint(f"{api_url}/api/live/", "API liveness probe"))
    results.append(check_endpoint(f"{api_url}/swagger/", "API documentation", check_content="Swagger"))
    results.append(check_endpoint(f"{api_url}/admin/", "Admin panel", expected_status=302))
    results.append(check_endpoint(f"{api_url}/api/farms/", "Farms API endpoint", expected_status=401))  # Should require auth
    results.append(check_endpoint(f"{api_url}/api/products/", "Products API endpoint", expected_status=401))  # Should require auth
    
    # Output results
    if args.json:
        output = {
            'timestamp': datetime.now().isoformat(),
            'environment': env_name,
            'frontend_url': frontend_url,
            'api_url': api_url,
            'results': results
        }
        if args.output:
            with open(args.output, 'w') as f:
                json.dump(output, f, indent=2)
        else:
            print(json.dumps(output, indent=2))
    else:
        # Summary
        success_count = sum(1 for r in results if r['success'])
        total_count = len(results)
        
        print(f"\n{COLORS['BOLD']}Deployment Verification Summary:{COLORS['RESET']}")
        print(f"Environment: {env_name}")
        print(f"Frontend URL: {frontend_url}")
        print(f"API URL: {api_url}")
        print(f"Success Rate: {success_count}/{total_count} endpoints ({(success_count/total_count)*100:.1f}%)")
    
    # Generate markdown report if requested
    if args.markdown:
        report = generate_markdown_report(results, env_name, frontend_url, api_url)
        if args.output:
            with open(args.output, 'w') as f:
                f.write(report)
        else:
            print("\n" + "=" * 40 + "\n")
            print(report)
    
    # Return exit code based on success
    if success_count < total_count:
        sys.exit(1)

if __name__ == "__main__":
    main()

if __name__ == "__main__":
    main()
