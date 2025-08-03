import React from 'react';

/**
 * Simple health check component that returns a 200 OK response
 * Used by monitoring systems to verify frontend availability
 */
const Health = () => {
  return (
    <div>
      <h1>Health Check: OK</h1>
      <p>AgriTrace Frontend is running properly</p>
      <p>Status: 200</p>
      <p>Timestamp: {new Date().toISOString()}</p>
    </div>
  );
};

export default Health;
