from django.test import TestCase
from django.contrib.auth.models import User
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from core.models import Farm, Product, TraceabilityRecord
from core.serializers import FarmSerializer, ProductSerializer, TraceabilityRecordSerializer
import uuid
from django.utils import timezone


class FarmAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpassword'
        )
        self.client.force_authenticate(user=self.user)
        
        self.farm_data = {
            'name': 'Test Farm',
            'location': 'Test Location',
            'coordinates': '12.345,67.890',
            'size_hectares': 10.5,
            'description': 'A test farm',
            'is_certified_organic': True,
            'certification_details': 'Organic certification #12345'
        }
        
        self.farm = Farm.objects.create(
            owner=self.user,
            **self.farm_data
        )
    
    def test_get_all_farms(self):
        response = self.client.get(reverse('farm-list'))
        farms = Farm.objects.all()
        serializer = FarmSerializer(farms, many=True)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['results'], serializer.data)
    
    def test_create_farm(self):
        new_farm_data = {
            'name': 'New Test Farm',
            'location': 'New Location',
            'size_hectares': 20.5,
            'description': 'A new test farm'
        }
        
        response = self.client.post(
            reverse('farm-list'),
            new_farm_data,
            format='json'
        )
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Farm.objects.count(), 2)
        self.assertEqual(Farm.objects.get(name='New Test Farm').owner, self.user)
    
    def test_get_single_farm(self):
        response = self.client.get(
            reverse('farm-detail', kwargs={'pk': self.farm.id})
        )
        
        serializer = FarmSerializer(self.farm)
        self.assertEqual(response.data, serializer.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class ProductAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpassword'
        )
        self.client.force_authenticate(user=self.user)
        
        self.farm = Farm.objects.create(
            name='Test Farm',
            owner=self.user,
            location='Test Location',
            size_hectares=10.5
        )
        
        self.product_data = {
            'name': 'Test Product',
            'product_type': 'Vegetable',
            'farm': self.farm.id,
            'description': 'A test product',
            'harvest_date': timezone.now().date(),
            'quantity': 100.0,
            'unit': 'kg'
        }
        
        self.product = Product.objects.create(
            farm=self.farm,
            name=self.product_data['name'],
            product_type=self.product_data['product_type'],
            description=self.product_data['description'],
            harvest_date=self.product_data['harvest_date'],
            quantity=self.product_data['quantity'],
            unit=self.product_data['unit']
        )
    
    def test_get_all_products(self):
        response = self.client.get(reverse('product-list'))
        products = Product.objects.all()
        serializer = ProductSerializer(products, many=True)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['results'], serializer.data)
    
    def test_create_product(self):
        new_product_data = {
            'name': 'New Test Product',
            'product_type': 'Fruit',
            'farm': self.farm.id,
            'description': 'A new test product',
            'harvest_date': timezone.now().date().isoformat(),
            'quantity': 50.0,
            'unit': 'kg'
        }
        
        response = self.client.post(
            reverse('product-list'),
            new_product_data,
            format='json'
        )
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Product.objects.count(), 2)
        self.assertEqual(Product.objects.get(name='New Test Product').farm, self.farm)


class TraceabilityRecordAPITest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpassword'
        )
        self.client.force_authenticate(user=self.user)
        
        self.farm = Farm.objects.create(
            name='Test Farm',
            owner=self.user,
            location='Test Location',
            size_hectares=10.5
        )
        
        self.product = Product.objects.create(
            name='Test Product',
            product_type='Vegetable',
            farm=self.farm,
            quantity=100.0,
            unit='kg'
        )
        
        self.record_data = {
            'product': self.product.id,
            'record_type': 'Harvest',
            'location': 'Field A',
            'timestamp': timezone.now(),
            'notes': 'Test harvest record',
            'temperature': 25.5,
            'humidity': 60.0
        }
        
        self.record = TraceabilityRecord.objects.create(
            product=self.product,
            record_type=self.record_data['record_type'],
            location=self.record_data['location'],
            timestamp=self.record_data['timestamp'],
            handler=self.user,
            notes=self.record_data['notes'],
            temperature=self.record_data['temperature'],
            humidity=self.record_data['humidity']
        )
    
    def test_get_all_records(self):
        response = self.client.get(reverse('traceabilityrecord-list'))
        records = TraceabilityRecord.objects.all()
        serializer = TraceabilityRecordSerializer(records, many=True)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['results'], serializer.data)
    
    def test_create_record(self):
        new_record_data = {
            'product': self.product.id,
            'record_type': 'Processing',
            'location': 'Processing Facility',
            'timestamp': timezone.now().isoformat(),
            'notes': 'Test processing record',
            'temperature': 20.0,
            'humidity': 50.0
        }
        
        response = self.client.post(
            reverse('traceabilityrecord-list'),
            new_record_data,
            format='json'
        )
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(TraceabilityRecord.objects.count(), 2)
        self.assertEqual(
            TraceabilityRecord.objects.get(record_type='Processing').handler, 
            self.user
        )
