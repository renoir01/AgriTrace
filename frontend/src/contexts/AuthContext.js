import React, { createContext, useContext, useState, useEffect } from 'react';
import axios from 'axios';
import jwt_decode from 'jwt-decode';

// Create context
const AuthContext = createContext();

// Provider component
export const AuthProvider = ({ children }) => {
  const [currentUser, setCurrentUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem('authToken') || null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Check if token is expired
  const isTokenExpired = (token) => {
    if (!token) return true;
    try {
      const decoded = jwt_decode(token);
      return decoded.exp < Date.now() / 1000;
    } catch (error) {
      return true;
    }
  };

  // Set axios default headers
  useEffect(() => {
    if (token) {
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    } else {
      delete axios.defaults.headers.common['Authorization'];
    }
  }, [token]);

  // Check token validity on mount
  useEffect(() => {
    const checkAuth = async () => {
      if (token && !isTokenExpired(token)) {
        try {
          // Get user data
          const response = await axios.get('/api/v1/users/me/');
          setCurrentUser(response.data);
        } catch (error) {
          console.error('Failed to fetch user data:', error);
          logout();
        }
      } else if (token) {
        // Token exists but is expired
        logout();
      }
      setLoading(false);
    };

    checkAuth();
  }, [token]);

  // Login function
  const login = async (username, password) => {
    setError(null);
    try {
      const response = await axios.post('/api/v1/token/', { username, password });
      const { access, refresh } = response.data;
      
      localStorage.setItem('authToken', access);
      localStorage.setItem('refreshToken', refresh);
      setToken(access);
      
      // Get user data
      const userResponse = await axios.get('/api/v1/users/me/');
      setCurrentUser(userResponse.data);
      
      return true;
    } catch (error) {
      setError(error.response?.data?.detail || 'Login failed. Please check your credentials.');
      return false;
    }
  };

  // Register function
  const register = async (userData) => {
    setError(null);
    try {
      await axios.post('/api/v1/users/register/', userData);
      return true;
    } catch (error) {
      setError(error.response?.data || 'Registration failed. Please try again.');
      return false;
    }
  };

  // Logout function
  const logout = () => {
    localStorage.removeItem('authToken');
    localStorage.removeItem('refreshToken');
    setToken(null);
    setCurrentUser(null);
  };

  // Context value
  const value = {
    currentUser,
    isAuthenticated: !!currentUser,
    loading,
    error,
    login,
    register,
    logout
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
};

// Custom hook to use auth context
export const useAuth = () => {
  return useContext(AuthContext);
};
