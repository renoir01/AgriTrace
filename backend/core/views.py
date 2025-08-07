from rest_framework import viewsets, permissions, status, filters
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.http import JsonResponse
from .models import Farm, Product, TraceabilityRecord
from .serializers import UserSerializer, FarmSerializer, ProductSerializer, TraceabilityRecordSerializer


@api_view(['GET'])
@permission_classes([permissions.AllowAny])
def health_check(request):
    """Simple health check view function for container health checks"""
    return JsonResponse({'status': 'OK'})


class UserViewSet(viewsets.ReadOnlyModelViewSet):
    """API endpoint for viewing users"""
    queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    @action(detail=False, methods=['get'], url_path='me')
    def me(self, request):
        """Get current user's data"""
        serializer = self.get_serializer(request.user)
        return Response(serializer.data)
    
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny], url_path='register')
    def register(self, request):
        """Register a new user"""
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response(UserSerializer(user).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FarmViewSet(viewsets.ModelViewSet):
    """API endpoint for farms"""
    queryset = Farm.objects.all().order_by('name')
    serializer_class = FarmSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'location', 'owner__username']
    ordering_fields = ['name', 'established_date', 'size_hectares']
    
    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)
    
    @action(detail=True, methods=['get'])
    def products(self, request, pk=None):
        """Get all products for a specific farm"""
        farm = self.get_object()
        products = Product.objects.filter(farm=farm)
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data)


class ProductViewSet(viewsets.ModelViewSet):
    """API endpoint for agricultural products"""
    queryset = Product.objects.all().order_by('name')
    serializer_class = ProductSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'product_type', 'farm__name']
    ordering_fields = ['name', 'harvest_date', 'quantity']
    
    @action(detail=True, methods=['get'])
    def traceability(self, request, pk=None):
        """Get all traceability records for a specific product"""
        product = self.get_object()
        records = TraceabilityRecord.objects.filter(product=product).order_by('timestamp')
        serializer = TraceabilityRecordSerializer(records, many=True)
        return Response(serializer.data)


class TraceabilityRecordViewSet(viewsets.ModelViewSet):
    """API endpoint for traceability records"""
    queryset = TraceabilityRecord.objects.all().order_by('-timestamp')
    serializer_class = TraceabilityRecordSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['record_type', 'location', 'product__name']
    ordering_fields = ['timestamp', 'record_type']
    
    def perform_create(self, serializer):
        serializer.save(handler=self.request.user)
