from django.test import TestCase
from django.contrib.auth.models import User
from core.models import Farm, Product, TraceabilityRecord
from django.utils import timezone
import uuid


class FarmModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpassword'
        )
        
        self.farm = Farm.objects.create(
            name='Test Farm',
            owner=self.user,
            location='Test Location',
            coordinates='12.345,67.890',
            size_hectares=10.5,
            established_date=timezone.now().date(),
            description='A test farm',
            is_certified_organic=True,
            certification_details='Organic certification #12345'
        )
    
    def test_farm_creation(self):
        self.assertTrue(isinstance(self.farm, Farm))
        self.assertEqual(str(self.farm), 'Test Farm')
    
    def test_farm_fields(self):
        self.assertEqual(self.farm.name, 'Test Farm')
        self.assertEqual(self.farm.owner, self.user)
        self.assertEqual(self.farm.location, 'Test Location')
        self.assertEqual(self.farm.coordinates, '12.345,67.890')
        self.assertEqual(self.farm.size_hectares, 10.5)
        self.assertEqual(self.farm.description, 'A test farm')
        self.assertTrue(self.farm.is_certified_organic)
        self.assertEqual(self.farm.certification_details, 'Organic certification #12345')


class ProductModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpassword'
        )
        
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
            description='A test product',
            harvest_date=timezone.now().date(),
            quantity=100.0,
            unit='kg'
        )
    
    def test_product_creation(self):
        self.assertTrue(isinstance(self.product, Product))
        self.assertEqual(str(self.product), 'Test Product')
    
    def test_product_fields(self):
        self.assertEqual(self.product.name, 'Test Product')
        self.assertEqual(self.product.product_type, 'Vegetable')
        self.assertEqual(self.product.farm, self.farm)
        self.assertEqual(self.product.description, 'A test product')
        self.assertEqual(self.product.quantity, 100.0)
        self.assertEqual(self.product.unit, 'kg')


class TraceabilityRecordModelTest(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpassword'
        )
        
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
        
        self.record = TraceabilityRecord.objects.create(
            product=self.product,
            record_type='Harvest',
            location='Field A',
            timestamp=timezone.now(),
            handler=self.user,
            notes='Test harvest record',
            temperature=25.5,
            humidity=60.0
        )
    
    def test_record_creation(self):
        self.assertTrue(isinstance(self.record, TraceabilityRecord))
        self.assertEqual(str(self.record), f'Harvest record for Test Product')
    
    def test_record_fields(self):
        self.assertEqual(self.record.product, self.product)
        self.assertEqual(self.record.record_type, 'Harvest')
        self.assertEqual(self.record.location, 'Field A')
        self.assertEqual(self.record.handler, self.user)
        self.assertEqual(self.record.notes, 'Test harvest record')
        self.assertEqual(self.record.temperature, 25.5)
        self.assertEqual(self.record.humidity, 60.0)
