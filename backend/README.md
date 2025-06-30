# AgriTrace Backend

Django REST API backend for the AgriTrace agricultural supply chain traceability platform.

## Features

- RESTful API with Django REST Framework
- JWT Authentication
- PostgreSQL database integration
- Swagger/OpenAPI documentation
- Comprehensive test suite
- Docker containerization

## Directory Structure

```
backend/
├── agritrace_project/  # Django project settings
├── core/              # Main application module
│   ├── migrations/    # Database migrations
│   ├── models/        # Data models
│   ├── serializers/   # API serializers
│   ├── tests/         # Test suite
│   └── views/         # API views and viewsets
├── logs/              # Application logs
├── media/             # User-uploaded files
├── static/            # Static files
└── requirements.txt   # Python dependencies
```

## Setup Instructions

### Prerequisites

- Python 3.8+
- PostgreSQL 12+ (optional, SQLite for development)
- Virtual environment tool (venv, virtualenv, etc.)

### Local Development Setup

1. **Create and activate a virtual environment**

```bash
python -m venv venv
venv\Scripts\activate  # On Windows
source venv/bin/activate  # On Unix/macOS
```

2. **Install dependencies**

```bash
pip install -r requirements.txt
```

3. **Set up environment variables**

Create a `.env` file in the backend directory based on `.env.example` in the root directory:

```
DEBUG=True
SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=localhost,127.0.0.1

# Use SQLite for development
DB_ENGINE=django.db.backends.sqlite3
DB_NAME=db.sqlite3
```

4. **Run migrations**

```bash
python manage.py migrate
```

5. **Create a superuser**

```bash
python manage.py createsuperuser
```

6. **Run the development server**

```bash
python manage.py runserver
```

7. **Access the API**

- API Root: http://localhost:8000/api/v1/
- Admin Interface: http://localhost:8000/admin/
- API Documentation: http://localhost:8000/swagger/ or http://localhost:8000/redoc/

## Testing

Run the test suite:

```bash
pytest
```

Run with coverage report:

```bash
pytest --cov=core
```

## Linting

```bash
flake8
black .
```

## Docker Deployment

See the Docker Compose configuration in the root directory for containerized deployment.
