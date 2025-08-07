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
  CardHeader
} from '@mui/material';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowBack as ArrowBackIcon, Edit as EditIcon } from '@mui/icons-material';

const FarmDetail = () => {
  const { farmId } = useParams();
  const navigate = useNavigate();
  const [farm, setFarm] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchFarmDetails = async () => {
      try {
        // In a real app, this would be an API call to the backend
        // const response = await axios.get(`/api/v1/farms/${farmId}/`);
        // setFarm(response.data);
        
        // For now, using mock data
        setFarm({
          id: farmId,
          name: 'Green Valley Farm',
          location: 'California',
          address: '123 Farm Road, Greenville, CA 95305',
          size: '120 acres',
          owner: 'John Smith',
          crops: ['Corn', 'Wheat', 'Soybeans'],
          certifications: ['Organic', 'Sustainable'],
          description: 'Green Valley Farm is a family-owned operation focused on sustainable farming practices. Established in 1985, the farm produces a variety of crops using organic methods.',
          coordinates: { lat: 37.7749, lng: -122.4194 }
        });
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch farm details');
        setLoading(false);
        console.error(err);
      }
    };

    fetchFarmDetails();
  }, [farmId]);

  const handleBack = () => {
    navigate('/farms');
  };

  const handleEdit = () => {
    navigate(`/farms/${farmId}/edit`);
  };

  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
        <CircularProgress />
      </Box>
    );
  }

  if (error || !farm) {
    return (
      <Container maxWidth="lg">
        <Typography color="error" variant="h6" sx={{ mt: 4 }}>
          {error || 'Farm not found'}
        </Typography>
        <Button
          variant="outlined"
          startIcon={<ArrowBackIcon />}
          onClick={handleBack}
          sx={{ mt: 2 }}
        >
          Back to Farms
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
              {farm.name}
            </Typography>
          </Box>
          <Button
            variant="contained"
            color="primary"
            startIcon={<EditIcon />}
            onClick={handleEdit}
          >
            Edit Farm
          </Button>
        </Box>

        <Grid container spacing={3}>
          <Grid item xs={12} md={8}>
            <Paper sx={{ p: 3, mb: 3 }}>
              <Typography variant="h6" gutterBottom>
                Farm Details
              </Typography>
              <Divider sx={{ mb: 2 }} />
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Location
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {farm.location}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Size
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {farm.size}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Owner
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {farm.owner}
                  </Typography>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Address
                  </Typography>
                  <Typography variant="body1" gutterBottom>
                    {farm.address}
                  </Typography>
                </Grid>
                <Grid item xs={12}>
                  <Typography variant="subtitle2" color="text.secondary">
                    Description
                  </Typography>
                  <Typography variant="body1" paragraph>
                    {farm.description}
                  </Typography>
                </Grid>
              </Grid>
            </Paper>
          </Grid>
          
          <Grid item xs={12} md={4}>
            <Card sx={{ mb: 3 }}>
              <CardHeader title="Crops" />
              <CardContent>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                  {farm.crops.map((crop, index) => (
                    <Chip key={index} label={crop} color="primary" variant="outlined" />
                  ))}
                </Box>
              </CardContent>
            </Card>
            
            <Card>
              <CardHeader title="Certifications" />
              <CardContent>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                  {farm.certifications.map((cert, index) => (
                    <Chip key={index} label={cert} color="success" />
                  ))}
                </Box>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      </Box>
    </Container>
  );
};

export default FarmDetail;
