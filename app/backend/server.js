const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = 8080;

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

app.get('/api/health', (req, res) => res.status(200).json({ status: 'Backend is running' }));
app.get('/api/db-check', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT NOW()');
    // Send a proper JSON success message
    res.status(200).json({ db_time: result.rows[0].now });
    client.release();
  } catch (err) {
    console.error('Database connection error:', err);
    // THIS IS THE FIX: Send a proper JSON error message
    res.status(500).json({ error: 'Database connection error!', details: err.message });
  }
});

app.listen(PORT, () => console.log(`Server listening on port ${PORT}`));
