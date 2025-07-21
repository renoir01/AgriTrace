import React, { useState, useEffect } from 'react';
import { 
  Box, 
  Typography, 
  Container, 
  Paper, 
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TablePagination,
  IconButton,
  Tooltip,
  CircularProgress
} from '@mui/material';
import { Add as AddIcon, Visibility as VisibilityIcon } from '@mui/icons-material';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';

const FarmsList = () => {
  const [farms, setFarms] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchFarms = async () => {
      try {
        // In a real app, this would be an API call to the backend
        // const response = await axios.get('/api/v1/farms/');
        // setFarms(response.data);
        
        // For now, using mock data
        setFarms([
          { id: 1, name: 'Green Valley Farm', location: 'California', size: '120 acres', owner: 'John Smith', crops: 'Corn, Wheat' },
          { id: 2, name: 'Sunshine Orchards', location: 'Florida', size: '85 acres', owner: 'Maria Garcia', crops: 'Oranges, Lemons' },
          { id: 3, name: 'Mountain View Ranch', location: 'Colorado', size: '350 acres', owner: 'Robert Johnson', crops: 'Cattle, Hay' }
        ]);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch farms');
        setLoading(false);
        console.error(err);
      }
    };

    fetchFarms();
  }, []);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleViewFarm = (farmId) => {
    navigate(`/farms/${farmId}`);
  };

  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Container maxWidth="lg">
        <Typography color="error" variant="h6" sx={{ mt: 4 }}>
          {error}
        </Typography>
      </Container>
    );
  }

  return (
    <Container maxWidth="lg">
      <Box sx={{ mt: 4, mb: 4 }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
          <Typography variant="h4" component="h1">
            Farms
          </Typography>
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            component={Link}
            to="/farms/new"
          >
            Add Farm
          </Button>
        </Box>

        <Paper sx={{ width: '100%', overflow: 'hidden' }}>
          <TableContainer sx={{ maxHeight: 440 }}>
            <Table stickyHeader aria-label="farms table">
              <TableHead>
                <TableRow>
                  <TableCell>Name</TableCell>
                  <TableCell>Location</TableCell>
                  <TableCell>Size</TableCell>
                  <TableCell>Owner</TableCell>
                  <TableCell>Crops</TableCell>
                  <TableCell align="right">Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {farms
                  .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                  .map((farm) => (
                    <TableRow hover key={farm.id}>
                      <TableCell>{farm.name}</TableCell>
                      <TableCell>{farm.location}</TableCell>
                      <TableCell>{farm.size}</TableCell>
                      <TableCell>{farm.owner}</TableCell>
                      <TableCell>{farm.crops}</TableCell>
                      <TableCell align="right">
                        <Tooltip title="View Details">
                          <IconButton
                            color="primary"
                            onClick={() => handleViewFarm(farm.id)}
                          >
                            <VisibilityIcon />
                          </IconButton>
                        </Tooltip>
                      </TableCell>
                    </TableRow>
                  ))}
              </TableBody>
            </Table>
          </TableContainer>
          <TablePagination
            rowsPerPageOptions={[5, 10, 25]}
            component="div"
            count={farms.length}
            rowsPerPage={rowsPerPage}
            page={page}
            onPageChange={handleChangePage}
            onRowsPerPageChange={handleChangeRowsPerPage}
          />
        </Paper>
      </Box>
    </Container>
  );
};

export default FarmsList;
