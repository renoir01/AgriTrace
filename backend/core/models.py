from django.db import models
from django.contrib.auth.models import User
import uuid


class Farm(models.Model):
    """Model representing a farm in the agricultural supply chain"""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='farms')
    location = models.CharField(max_length=255)
    coordinates = models.CharField(max_length=100, blank=True, null=True)
    size_hectares = models.DecimalField(max_digits=10, decimal_places=2)
    established_date = models.DateField()
    description = models.TextField(blank=True, null=True)
    is_certified_organic = models.BooleanField(default=False)
    certification_details = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.name


class Product(models.Model):
    """Model representing an agricultural product"""
    PRODUCT_TYPES = [
        ('CROP', 'Crop'),
        ('LIVESTOCK', 'Livestock'),
        ('DAIRY', 'Dairy'),
        ('PROCESSED', 'Processed Food'),
    ]
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    product_type = models.CharField(max_length=20, choices=PRODUCT_TYPES)
    farm = models.ForeignKey(Farm, on_delete=models.CASCADE, related_name='products')
    description = models.TextField(blank=True, null=True)
    harvest_date = models.DateField(null=True, blank=True)
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    unit = models.CharField(max_length=50)  # e.g., kg, liters, pieces
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.name


class TraceabilityRecord(models.Model):
    """Model for tracking products through the supply chain"""
    RECORD_TYPES = [
        ('HARVEST', 'Harvest'),
        ('PROCESSING', 'Processing'),
        ('PACKAGING', 'Packaging'),
        ('TRANSPORT', 'Transport'),
        ('STORAGE', 'Storage'),
        ('DISTRIBUTION', 'Distribution'),
        ('RETAIL', 'Retail'),
    ]
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='traceability_records')
    record_type = models.CharField(max_length=20, choices=RECORD_TYPES)
    location = models.CharField(max_length=255)
    timestamp = models.DateTimeField()
    handler = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='handled_records')
    notes = models.TextField(blank=True, null=True)
    temperature = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)  # For storage/transport
    humidity = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)  # For storage
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.record_type} record for {self.product.name}"
