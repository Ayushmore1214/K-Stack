import React, { useState } from 'react';
import './App.css';

function App() {
  const [status, setStatus] = useState('');
  const fetchData = async (endpoint) => {
    try {
      const res = await fetch(endpoint);
      const data = await res.json();
      return JSON.stringify(data);
    } catch (err) {
      return `Error: ${err.message}`;
    }
  };

  return (
    <div className="App">
      <h1>Project Titan EKS</h1>
      <div className="buttons">
        <button onClick={async () => setStatus(await fetchData('/api/health'))}>Check Backend Status</button>
        <button onClick={async () => setStatus(await fetchData('/api/db-check'))}>Check DB Connection</button>
      </div>
      <div className="response">
        <p>API Response:</p>
        <code>{status}</code>
      </div>
    </div>
  );
}

export default App;
