import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { Box } from '@mui/material';
import { useAuth } from './contexts/AuthContext';

// Layouts
import MainLayout from './layouts/MainLayout';

// Pages
import Dashboard from './pages/Dashboard';
import FarmsList from './pages/farms/FarmsList';
import FarmDetail from './pages/farms/FarmDetail';
import ProductsList from './pages/products/ProductsList';
import ProductDetail from './pages/products/ProductDetail';
import TraceabilityList from './pages/traceability/TraceabilityList';
import TraceabilityDetail from './pages/traceability/TraceabilityDetail';
import Login from './pages/auth/Login';
import Register from './pages/auth/Register';
import NotFound from './pages/NotFound';
import Health from './pages/Health';

// Protected route component
const ProtectedRoute = ({ children }) => {
  const { isAuthenticated } = useAuth();
  
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }
  
  return children;
};

function App() {
  return (
    <Box sx={{ display: 'flex' }}>
      <Routes>
        {/* Public health check endpoint */}
        <Route path="/health" element={<Health />} />
        
        {/* Auth routes */}
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        
        {/* Protected routes */}
        <Route path="/" element={
          <ProtectedRoute>
            <MainLayout />
          </ProtectedRoute>
        }>
          <Route index element={<Dashboard />} />
          <Route path="farms">
            <Route index element={<FarmsList />} />
            <Route path=":farmId" element={<FarmDetail />} />
          </Route>
          <Route path="products">
            <Route index element={<ProductsList />} />
            <Route path=":productId" element={<ProductDetail />} />
          </Route>
          <Route path="traceability">
            <Route index element={<TraceabilityList />} />
            <Route path=":recordId" element={<TraceabilityDetail />} />
          </Route>
        </Route>
        
        {/* 404 route */}
        <Route path="*" element={<NotFound />} />
      </Routes>
    </Box>
  );
}

export default App;
