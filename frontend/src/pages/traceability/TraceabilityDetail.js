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
  ListItemText,
  ListItemIcon,
  Avatar,
  Stack
} from '@mui/material';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { 
  ArrowBack as ArrowBackIcon, 
  Edit as EditIcon,
  Agriculture as AgricultureIcon,
  LocalShipping as ShippingIcon,
  Inventory as InventoryIcon,
  Nature as NatureIcon,
  Storefront as StorefrontIcon
} from '@mui/icons-material';

const TraceabilityDetail = () => {
  const { recordId } = useParams();
  const navigate = useNavigate();
  const [record, setRecord] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchRecordDetails = async () => {
      try {
        // In a real app, this would be an API call to the backend
        // const response = await axios.get(`/api/v1/traceability/${recordId}/`);
        // setRecord(response.data);
        
        // For now, using mock data
        setRecord({
          id: recordId,
          product: {
            id: 1,
            name: 'Organic Corn',
            category: 'Grain'
          },
          farm: {
            id: 1,
            name: 'Green Valley Farm',
            location: 'California'
          },
          activity: 'Harvesting',
          date: '2025-05-15',
          status: 'Completed',
          description: 'Harvesting of organic corn from Field B-7 using sustainable harvesting methods.',
          personnel: 'John Smith, Maria Rodriguez',
          equipment: 'Harvester H-201, Tractor T-105',
          conditions: 'Sunny, 75°F, Humidity 45%',
          notes: 'Excellent yield this season. Crop quality is high with minimal pest damage.',
          relatedRecords: [
            { id: 101, activity: 'Planting', date: '2025-04-01', status: 'Completed' },
            { id: 102, activity: 'Harvesting', date: '2025-05-15', status: 'Completed' },
            { id: 103, activity: 'Processing', date: '2025-05-20', status: 'Completed' },
            { id: 104, activity: 'Packaging', date: '2025-05-25', status: 'In Progress' }
          ],
          certifications: ['Organic', 'Non-GMO'],
          images: [
            { id: 1, url: 'https://via.placeholder.com/300x200?text=Harvest+Image+1', caption: 'Field B-7 before harvest' },
            { id: 2, url: 'https://via.placeholder.com/300x200?text=Harvest+Image+2', caption: 'Harvesting in progress' }
          ]
        });
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch traceability record details');
        setLoading(false);
        console.error(err);
      }
    };

    fetchRecordDetails();
  }, [recordId]);

  const handleBack = () => {
    navigate('/traceability');
  };

  const handleEdit = () => {
    navigate(`/traceability/${recordId}/edit`);
  };

  const getActivityIcon = (activity) => {
    switch (activity.toLowerCase()) {
      case 'planting':
        return <NatureIcon />;
      case 'harvesting':
        return <AgricultureIcon />;
      case 'processing':
        return <InventoryIcon />;
      case 'packaging':
        return <InventoryIcon />;
      case 'shipping':
        return <ShippingIcon />;
      case 'retail':
        return <StorefrontIcon />;
      default:
        return <InventoryIcon />;
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'Completed':
        return 'success';
      case 'In Progress':
        return 'warning';
      case 'Planned':
        return 'info';
      default:
        return 'default';
    }
  };

  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
        <CircularProgress />
      </Box>
    );
  }

  if (error || !record) {
    return (
      <Container maxWidth="lg">
        <Typography color="error" variant="h6" sx={{ mt: 4 }}>
          {error || 'Traceability record not found'}
        </Typography>
        <Button
          variant="outlined"
          startIcon={<ArrowBackIcon />}
          onClick={handleBack}
          sx={{ mt: 2 }}
        >
          Back to Traceability Records
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
              {record.activity} - {record.product.name}
            </Typography>
          </Box>
          <Button
            variant="contained"
            color="primary"
            startIcon={<EditIcon />}
            onClick={handleEdit}
          >
            Edit Record
          </Button>
        </Box>

        <Grid container spacing={3}>
          <Grid item xs={12} md={8}>
            <Paper sx={{ p: 3, mb: 3 }}>
              <Typography variant="h6" gutterBottom>
                Activity Details
              </Typography>
              <Divider sx={{ mb: 2 }} />
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Product
                  </Typography>
                  <Typography 
                    variant="body1" 
                    gutterBottom
                    component={Link}
                    to={`/products/${record.product.id}`}
                    sx={{ 
                      color: 'primary.main', 
                      textDecoration: 'none',
                      '&:hover': { textDecoration: 'underline' }
                    }}
                  >
                    {record.product.name} ({record.product.category})
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Farm
                  </Typography>
                  <Typography 
                    variant="body1" 
                    gutterBottom
                    component={Link}
                    to={`/farms/${record.farm.id}`}
                    sx={{ 
                      color: 'primary.main', 
                      textDecoration: 'none',
                      '&:hover': { textDecoration: 'underline' }
                    }}
                  >
                    {record.farm.name} ({record.farm.location})
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Date
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {record.date}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Status
                  </Typography>
                  <Chip 
                    label={record.status} 
                    color={getStatusColor(record.status)} 
                    size="small" 
                  />
                </Grid>
                <Grid item xs={12}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Description
                  </Typography>
                  <Typography variant="body1" paragraph>
                    {record.description}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Personnel
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {record.personnel}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Equipment
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {record.equipment}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Conditions
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {record.conditions}
                  </Typography>
                </Grid>
                <Grid item xs={12}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Notes
                  </Typography>
                  <Typography variant="body1" paragraph>
                    {record.notes}
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
                  {record.certifications.map((cert, index) => (
                    <Chip key={index} label={cert} color="success" />
                  ))}
                </Box>
              </CardContent>
            </Card>
            
            <Card sx={{ mb: 3 }}>
              <CardHeader title="Images" />
              <CardContent>
                <Grid container spacing={2}>
                  {record.images.map((image) => (
                    <Grid item xs={12} key={image.id}>
                      <img 
                        src={image.url} 
                        alt={image.caption} 
                        style={{ width: '100%', borderRadius: '4px' }} 
                      />
                      <Typography variant="caption" display="block" sx={{ mt: 0.5 }}>
                        {image.caption}
                      </Typography>
                    </Grid>
                  ))}
                </Grid>
              </CardContent>
            </Card>
          </Grid>
          
          <Grid item xs={12}>
            <Paper sx={{ p: 3 }}>
              <Typography variant="h6" gutterBottom>
                Product Journey
              </Typography>
              <Divider sx={{ mb: 2 }} />
              <Box sx={{ width: '100%' }}>
                {record.relatedRecords.map((relatedRecord, index) => (
                  <Box 
                    key={relatedRecord.id}
                    sx={{
                      display: 'flex',
                      mb: 2,
                      position: 'relative',
                      '&:after': index < record.relatedRecords.length - 1 ? {
                        content: '""',
                        position: 'absolute',
                        left: '28px',
                        top: '40px',
                        height: index < record.relatedRecords.length - 1 ? '40px' : 0,
                        width: '2px',
                        backgroundColor: 'divider'
                      } : {}
                    }}
                  >
                    <Box sx={{ mr: 2, display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                      <Avatar
                        sx={{
                          bgcolor: relatedRecord.id === parseInt(recordId) ? 'primary.main' : 'grey.400',
                          color: 'white',
                          width: 40,
                          height: 40
                        }}
                      >
                        {getActivityIcon(relatedRecord.activity)}
                      </Avatar>
                    </Box>
                    
                    <Box sx={{ flex: 1 }}>
                      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <Typography 
                          variant="h6" 
                          component={Link}
                          to={`/traceability/${relatedRecord.id}`}
                          sx={{ 
                            color: relatedRecord.id === parseInt(recordId) ? 'primary.main' : 'text.primary',
                            textDecoration: 'none',
                            fontWeight: relatedRecord.id === parseInt(recordId) ? 'bold' : 'normal',
                            '&:hover': { textDecoration: 'underline' }
                          }}
                        >
                          {relatedRecord.activity}
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                          {relatedRecord.date}
                        </Typography>
                      </Box>
                      <Box sx={{ mt: 0.5 }}>
                        <Chip 
                          label={relatedRecord.status} 
                          color={getStatusColor(relatedRecord.status)} 
                          size="small" 
                        />
                      </Box>
                    </Box>
                  </Box>
                ))}
              </Box>
            </Paper>
          </Grid>
        </Grid>
      </Box>
    </Container>
  );
};

export default TraceabilityDetail;
