import React, { useState, useEffect } from 'react';
import axios from 'axios';

// IMPORTANT: Replace this with your actual backend service URL when deployed
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080'; 

function App() {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState('');

  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = async () => {
    try {
      const response = await axios.get(`${API_URL}/tasks`);
      setTasks(response.data);
    } catch (error) {
      console.error("Error fetching tasks:", error);
    }
  };

  const addTask = async () => {
    if (!newTask.trim()) return;
    try {
      await axios.post(`${API_URL}/tasks`, { description: newTask });
      setNewTask('');
      fetchTasks();
    } catch (error) {
      console.error("Error adding task:", error);
    }
  };

  const deleteTask = async (id) => {
    try {
      await axios.delete(`${API_URL}/tasks/${id}`);
      fetchTasks();
    } catch (error) {
      console.error("Error deleting task:", error);
    }
  };

  return (
    <div style={{ fontFamily: 'Arial, sans-serif', maxWidth: '500px', margin: '50px auto', padding: '20px', boxShadow: '0 0 10px rgba(0,0,0,0.1)' }}>
      <h1 style={{ textAlign: 'center' }}>To-Do List</h1>
      <div style={{ display: 'flex', marginBottom: '20px' }}>
        <input
          type="text"
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          placeholder="Add a new task"
          style={{ flex: 1, padding: '10px', border: '1px solid #ccc' }}
        />
        <button onClick={addTask} style={{ padding: '10px', border: 'none', backgroundColor: '#28a745', color: 'white', cursor: 'pointer' }}>Add</button>
      </div>
      <ul style={{ listStyle: 'none', padding: 0 }}>
        {tasks.map(task => (
          <li key={task.id} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px', borderBottom: '1px solid #eee' }}>
            <span>{task.description}</span>
            <button onClick={() => deleteTask(task.id)} style={{ border: 'none', backgroundColor: '#dc3545', color: 'white', cursor: 'pointer', padding: '5px 10px' }}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
