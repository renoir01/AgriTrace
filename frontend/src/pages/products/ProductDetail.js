import React, { useState, useEffect } from 'react';
import { 
  Box, 
  Typography, 
  Container, 
  Paper, 
  Grid,
  Button,
  Divider,
  Chip,
  CircularProgress,
  Card,
  CardContent,
  CardHeader,
  List,
  ListItem,
  ListItemText
} from '@mui/material';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowBack as ArrowBackIcon, Edit as EditIcon } from '@mui/icons-material';

const ProductDetail = () => {
  const { productId } = useParams();
  const navigate = useNavigate();
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchProductDetails = async () => {
      try {
        // In a real app, this would be an API call to the backend
        // const response = await axios.get(`/api/v1/products/${productId}/`);
        // setProduct(response.data);
        
        // For now, using mock data
        setProduct({
          id: productId,
          name: 'Organic Corn',
          category: 'Grain',
          farm: {
            id: 1,
            name: 'Green Valley Farm',
            location: 'California'
          },
          certifications: ['Organic', 'Non-GMO'],
          quantity: '5000 kg',
          harvestDate: '2025-05-15',
          description: 'Premium organic corn grown using sustainable farming practices. No pesticides or chemical fertilizers used.',
          nutritionalInfo: {
            calories: '365 kcal per 100g',
            protein: '9g per 100g',
            carbs: '74g per 100g',
            fat: '4.7g per 100g'
          },
          traceabilityRecords: [
            { id: 101, date: '2025-04-01', activity: 'Planting' },
            { id: 102, date: '2025-05-15', activity: 'Harvesting' },
            { id: 103, date: '2025-05-20', activity: 'Processing' },
            { id: 104, date: '2025-05-25', activity: 'Packaging' }
          ]
        });
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch product details');
        setLoading(false);
        console.error(err);
      }
    };

    fetchProductDetails();
  }, [productId]);

  const handleBack = () => {
    navigate('/products');
  };

  const handleEdit = () => {
    navigate(`/products/${productId}/edit`);
  };

  const handleViewFarm = (farmId) => {
    navigate(`/farms/${farmId}`);
  };

  const handleViewTraceability = (recordId) => {
    navigate(`/traceability/${recordId}`);
  };

  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
        <CircularProgress />
      </Box>
    );
  }

  if (error || !product) {
    return (
      <Container maxWidth="lg">
        <Typography color="error" variant="h6" sx={{ mt: 4 }}>
          {error || 'Product not found'}
        </Typography>
        <Button
          variant="outlined"
          startIcon={<ArrowBackIcon />}
          onClick={handleBack}
          sx={{ mt: 2 }}
        >
          Back to Products
        </Button>
      </Container>
    );
  }

  return (
    <Container maxWidth="lg">
      <Box sx={{ mt: 4, mb: 4 }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
          <Box sx={{ display: 'flex', alignItems: 'center' }}>
            <Button
              variant="outlined"
              startIcon={<ArrowBackIcon />}
              onClick={handleBack}
              sx={{ mr: 2 }}
            >
              Back
            </Button>
            <Typography variant="h4" component="h1">
              {product.name}
            </Typography>
          </Box>
          <Button
            variant="contained"
            color="primary"
            startIcon={<EditIcon />}
            onClick={handleEdit}
          >
            Edit Product
          </Button>
        </Box>

        <Grid container spacing={3}>
          <Grid item xs={12} md={8}>
            <Paper sx={{ p: 3, mb: 3 }}>
              <Typography variant="h6" gutterBottom>
                Product Details
              </Typography>
              <Divider sx={{ mb: 2 }} />
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Category
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {product.category}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Farm
                  </Typography>
                  <Typography 
                    variant="body1" 
                    gutterBottom 
                    sx={{ 
                      color: 'primary.main', 
                      cursor: 'pointer',
                      '&:hover': { textDecoration: 'underline' }
                    }}
                    onClick={() => handleViewFarm(product.farm.id)}
                  >
                    {product.farm.name} ({product.farm.location})
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Quantity
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {product.quantity}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Harvest Date
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {product.harvestDate}
                  </Typography>
                </Grid>
                <Grid item xs={12}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Description
                  </Typography>
                  <Typography variant="body1" paragraph>
                    {product.description}
                  </Typography>
                </Grid>
              </Grid>
            </Paper>
          </Grid>
          
          <Grid item xs={12} md={4}>
            <Card sx={{ mb: 3 }}>
              <CardHeader title="Certifications" />
              <CardContent>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                  {product.certifications.map((cert, index) => (
                    <Chip key={index} label={cert} color="success" />
                  ))}
                </Box>
              </CardContent>
            </Card>
            
            <Card sx={{ mb: 3 }}>
              <CardHeader title="Nutritional Information" />
              <CardContent>
                <List dense>
                  {Object.entries(product.nutritionalInfo).map(([key, value]) => (
                    <ListItem key={key} disablePadding>
                      <ListItemText 
                        primary={`${key.charAt(0).toUpperCase() + key.slice(1)}: ${value}`} 
                      />
                    </ListItem>
                  ))}
                </List>
              </CardContent>
            </Card>
          </Grid>
          
          <Grid item xs={12}>
            <Paper sx={{ p: 3 }}>
              <Typography variant="h6" gutterBottom>
                Traceability Records
              </Typography>
              <Divider sx={{ mb: 2 }} />
              <List>
                {product.traceabilityRecords.map((record) => (
                  <ListItem 
                    key={record.id}
                    button
                    onClick={() => handleViewTraceability(record.id)}
                    sx={{ 
                      borderBottom: '1px solid',
                      borderColor: 'divider',
                      '&:last-child': { borderBottom: 'none' }
                    }}
                  >
                    <ListItemText 
                      primary={record.activity} 
                      secondary={record.date} 
                    />
                  </ListItem>
                ))}
              </List>
            </Paper>
          </Grid>
        </Grid>
      </Box>
    </Container>
  );
};

export default ProductDetail;
