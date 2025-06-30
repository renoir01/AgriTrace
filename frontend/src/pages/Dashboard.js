import React, { useState, useEffect } from 'react';
import { 
  Box, Grid, Paper, Typography, Card, CardContent, 
  CardHeader, Divider, List, ListItem, ListItemText,
  CircularProgress, Button
} from '@mui/material';
import { 
  Agriculture as FarmIcon,
  Inventory as ProductIcon,
  Timeline as TraceabilityIcon,
  TrendingUp as TrendingUpIcon
} from '@mui/icons-material';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const Dashboard = () => {
  const [stats, setStats] = useState({
    farmCount: 0,
    productCount: 0,
    traceabilityCount: 0,
    loading: true
  });
  const [recentActivity, setRecentActivity] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    // In a real app, we would fetch this data from the API
    // For now, we'll simulate loading and set dummy data
    const fetchData = async () => {
      try {
        // Simulate API calls
        setTimeout(() => {
          setStats({
            farmCount: 12,
            productCount: 48,
            traceabilityCount: 156,
            loading: false
          });
          
          setRecentActivity([
            { id: 1, type: 'Farm', name: 'Green Valley Farm', action: 'added', date: '2025-06-29' },
            { id: 2, type: 'Product', name: 'Organic Tomatoes', action: 'updated', date: '2025-06-28' },
            { id: 3, type: 'Traceability', name: 'Harvest Record #1234', action: 'added', date: '2025-06-27' },
            { id: 4, type: 'Farm', name: 'Sunshine Acres', action: 'updated', date: '2025-06-26' },
            { id: 5, type: 'Product', name: 'Fresh Lettuce', action: 'added', date: '2025-06-25' }
          ]);
        }, 1000);
        
        // In a real app, we would make actual API calls:
        // const farmResponse = await axios.get('/api/v1/farms/');
        // const productResponse = await axios.get('/api/v1/products/');
        // const traceabilityResponse = await axios.get('/api/v1/traceability/');
        // const activityResponse = await axios.get('/api/v1/activity/');
        
      } catch (error) {
        console.error('Error fetching dashboard data:', error);
      }
    };
    
    fetchData();
  }, []);

  const StatCard = ({ title, value, icon, color, onClick }) => (
    <Card 
      sx={{ 
        height: '100%', 
        display: 'flex', 
        flexDirection: 'column',
        cursor: 'pointer',
        transition: 'transform 0.2s',
        '&:hover': {
          transform: 'translateY(-4px)',
          boxShadow: 3
        }
      }}
      onClick={onClick}
    >
      <CardContent sx={{ flexGrow: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
        <Box sx={{ 
          backgroundColor: `${color}.light`, 
          borderRadius: '50%', 
          width: 60, 
          height: 60, 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center',
          mb: 2
        }}>
          {React.cloneElement(icon, { sx: { fontSize: 32, color: `${color}.main` } })}
        </Box>
        <Typography variant="h4" component="div" sx={{ fontWeight: 'bold' }}>
          {stats.loading ? <CircularProgress size={24} /> : value}
        </Typography>
        <Typography variant="body1" color="text.secondary" sx={{ mt: 1 }}>
          {title}
        </Typography>
      </CardContent>
    </Card>
  );

  return (
    <Box>
      <Typography variant="h4" gutterBottom component="div" sx={{ mb: 4 }}>
        Dashboard
      </Typography>
      
      <Grid container spacing={3}>
        {/* Stats Cards */}
        <Grid item xs={12} sm={6} md={4}>
          <StatCard 
            title="Farms" 
            value={stats.farmCount} 
            icon={<FarmIcon />} 
            color="primary"
            onClick={() => navigate('/farms')}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4}>
          <StatCard 
            title="Products" 
            value={stats.productCount} 
            icon={<ProductIcon />} 
            color="secondary"
            onClick={() => navigate('/products')}
          />
        </Grid>
        <Grid item xs={12} sm={6} md={4}>
          <StatCard 
            title="Traceability Records" 
            value={stats.traceabilityCount} 
            icon={<TraceabilityIcon />} 
            color="success"
            onClick={() => navigate('/traceability')}
          />
        </Grid>
        
        {/* Recent Activity */}
        <Grid item xs={12} md={6}>
          <Card sx={{ height: '100%' }}>
            <CardHeader title="Recent Activity" />
            <Divider />
            <CardContent>
              {stats.loading ? (
                <Box sx={{ display: 'flex', justifyContent: 'center', p: 2 }}>
                  <CircularProgress />
                </Box>
              ) : (
                <List>
                  {recentActivity.map((activity) => (
                    <React.Fragment key={activity.id}>
                      <ListItem>
                        <ListItemText
                          primary={`${activity.name} (${activity.type})`}
                          secondary={`${activity.action} on ${activity.date}`}
                        />
                      </ListItem>
                      <Divider component="li" />
                    </React.Fragment>
                  ))}
                </List>
              )}
            </CardContent>
          </Card>
        </Grid>
        
        {/* Quick Actions */}
        <Grid item xs={12} md={6}>
          <Card sx={{ height: '100%' }}>
            <CardHeader title="Quick Actions" />
            <Divider />
            <CardContent>
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <Button 
                    variant="contained" 
                    color="primary" 
                    fullWidth
                    startIcon={<FarmIcon />}
                    onClick={() => navigate('/farms')}
                  >
                    Add New Farm
                  </Button>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Button 
                    variant="contained" 
                    color="secondary" 
                    fullWidth
                    startIcon={<ProductIcon />}
                    onClick={() => navigate('/products')}
                  >
                    Add New Product
                  </Button>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Button 
                    variant="contained" 
                    color="success" 
                    fullWidth
                    startIcon={<TraceabilityIcon />}
                    onClick={() => navigate('/traceability')}
                  >
                    Add Traceability Record
                  </Button>
                </Grid>
                <Grid item xs={12} sm={6}>
                  <Button 
                    variant="outlined" 
                    color="primary" 
                    fullWidth
                    startIcon={<TrendingUpIcon />}
                  >
                    View Analytics
                  </Button>
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Dashboard;
