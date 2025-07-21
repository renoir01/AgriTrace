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
  CircularProgress,
  Chip
} from '@mui/material';
import { Add as AddIcon, Visibility as VisibilityIcon } from '@mui/icons-material';
import { Link, useNavigate } from 'react-router-dom';

const TraceabilityList = () => {
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchTraceabilityRecords = async () => {
      try {
        // In a real app, this would be an API call to the backend
        // const response = await axios.get('/api/v1/traceability/');
        // setRecords(response.data);
        
        // For now, using mock data
        setRecords([
          { 
            id: 101, 
            product: 'Organic Corn', 
            productId: 1,
            farm: 'Green Valley Farm', 
            farmId: 1,
            activity: 'Planting', 
            date: '2025-04-01', 
            status: 'Completed' 
          },
          { 
            id: 102, 
            product: 'Organic Corn', 
            productId: 1,
            farm: 'Green Valley Farm', 
            farmId: 1,
            activity: 'Harvesting', 
            date: '2025-05-15', 
            status: 'Completed' 
          },
          { 
            id: 103, 
            product: 'Organic Corn', 
            productId: 1,
            farm: 'Green Valley Farm', 
            farmId: 1,
            activity: 'Processing', 
            date: '2025-05-20', 
            status: 'Completed' 
          },
          { 
            id: 104, 
            product: 'Organic Corn', 
            productId: 1,
            farm: 'Green Valley Farm', 
            farmId: 1,
            activity: 'Packaging', 
            date: '2025-05-25', 
            status: 'In Progress' 
          },
          { 
            id: 201, 
            product: 'Valencia Oranges', 
            productId: 2,
            farm: 'Sunshine Orchards', 
            farmId: 2,
            activity: 'Harvesting', 
            date: '2025-06-10', 
            status: 'Completed' 
          }
        ]);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch traceability records');
        setLoading(false);
        console.error(err);
      }
    };

    fetchTraceabilityRecords();
  }, []);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleViewRecord = (recordId) => {
    navigate(`/traceability/${recordId}`);
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
            Traceability Records
          </Typography>
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            component={Link}
            to="/traceability/new"
          >
            Add Record
          </Button>
        </Box>

        <Paper sx={{ width: '100%', overflow: 'hidden' }}>
          <TableContainer sx={{ maxHeight: 440 }}>
            <Table stickyHeader aria-label="traceability records table">
              <TableHead>
                <TableRow>
                  <TableCell>Product</TableCell>
                  <TableCell>Farm</TableCell>
                  <TableCell>Activity</TableCell>
                  <TableCell>Date</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell align="right">Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {records
                  .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                  .map((record) => (
                    <TableRow hover key={record.id}>
                      <TableCell>
                        <Link 
                          to={`/products/${record.productId}`}
                          style={{ textDecoration: 'none', color: '#1976d2' }}
                        >
                          {record.product}
                        </Link>
                      </TableCell>
                      <TableCell>
                        <Link 
                          to={`/farms/${record.farmId}`}
                          style={{ textDecoration: 'none', color: '#1976d2' }}
                        >
                          {record.farm}
                        </Link>
                      </TableCell>
                      <TableCell>{record.activity}</TableCell>
                      <TableCell>{record.date}</TableCell>
                      <TableCell>
                        <Chip 
                          label={record.status} 
                          color={getStatusColor(record.status)} 
                          size="small" 
                        />
                      </TableCell>
                      <TableCell align="right">
                        <Tooltip title="View Details">
                          <IconButton
                            color="primary"
                            onClick={() => handleViewRecord(record.id)}
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
            count={records.length}
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

export default TraceabilityList;
