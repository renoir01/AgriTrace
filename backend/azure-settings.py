# Azure App Service specific Django settings
import os
from decouple import config
import dj_database_url

# Define BASE_DIR as the root of your Django project
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Azure App Service environment detection
WEBSITE_HOSTNAME = os.environ.get('WEBSITE_HOSTNAME')

if WEBSITE_HOSTNAME:
    # Running on Azure App Service
    ALLOWED_HOSTS = [WEBSITE_HOSTNAME, '127.0.0.1', 'localhost']
    DEBUG = False
    
    # Database configuration for Azure PostgreSQL
    if 'DATABASE_URL' in os.environ:
        DATABASES = {
            'default': dj_database_url.parse(os.environ['DATABASE_URL'])
        }
    
    # Static files configuration
    STATIC_URL = '/static/'
    STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
    STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
    
    # Media files configuration
    MEDIA_URL = '/media/'
    MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
    
    # CORS settings for Azure
    CORS_ALLOWED_ORIGINS = [
        f"https://{WEBSITE_HOSTNAME}",
    ]
    
    # Add your frontend domain when deployed (uncomment and update if needed)
    # CORS_ALLOWED_ORIGINS.append("https://your-frontend-app.azurewebsites.net")
    
    # Security settings
    SECURE_SSL_REDIRECT = True
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

else:
    # Local development settings
    DEBUG = True
    ALLOWED_HOSTS = ['127.0.0.1', 'localhost']
    
    # Local database configuration
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': config('DB_NAME', default='agritrace_db'),
            'USER': config('DB_USER', default='postgres'),
            'PASSWORD': config('DB_PASSWORD', default='password'),
            'HOST': config('DB_HOST', default='localhost'),
            'PORT': config('DB_PORT', default='5432'),
        }
    }
