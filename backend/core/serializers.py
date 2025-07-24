from rest_framework import serializers
from .models import Farm, Product, TraceabilityRecord
from django.contrib.auth.models import User


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)
    
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }
    
    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User.objects.create_user(**validated_data)
        user.set_password(password)
        user.save()
        return user


class FarmSerializer(serializers.ModelSerializer):
    owner_name = serializers.SerializerMethodField()
    
    class Meta:
        model = Farm
        fields = [
            'id', 'name', 'owner', 'owner_name', 'location', 'coordinates',
            'size_hectares', 'established_date', 'description',
            'is_certified_organic', 'certification_details',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['owner']
    
    def get_owner_name(self, obj):
        return f"{obj.owner.first_name} {obj.owner.last_name}" if obj.owner.first_name else obj.owner.username


class ProductSerializer(serializers.ModelSerializer):
    farm_name = serializers.SerializerMethodField()
    
    class Meta:
        model = Product
        fields = [
            'id', 'name', 'product_type', 'farm', 'farm_name',
            'description', 'harvest_date', 'quantity', 'unit',
            'created_at', 'updated_at'
        ]
    
    def get_farm_name(self, obj):
        return obj.farm.name


class TraceabilityRecordSerializer(serializers.ModelSerializer):
    product_name = serializers.SerializerMethodField()
    handler_name = serializers.SerializerMethodField()
    
    class Meta:
        model = TraceabilityRecord
        fields = [
            'id', 'product', 'product_name', 'record_type', 'location',
            'timestamp', 'handler', 'handler_name', 'notes',
            'temperature', 'humidity', 'created_at'
        ]
    
    def get_product_name(self, obj):
        return obj.product.name
    
    def get_handler_name(self, obj):
        if obj.handler:
            return f"{obj.handler.first_name} {obj.handler.last_name}" if obj.handler.first_name else obj.handler.username
        return None
