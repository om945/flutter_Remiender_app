import express from 'express';
import {
  handleDeletetodos,
  handleEditTodos,
  handleGenerateNewTodos,
  handleGetTodos,
} from '../controller/todo.js';
import auth from '../middleware/auth.js';

const router = express.Router();

router.post('/api/todo', auth, handleGenerateNewTodos);
router.get('/api/todo', auth, handleGetTodos);
router.patch('/api/todo', auth, handleEditTodos);
router.delete('/api/todo', auth, handleDeletetodos);

export default router;
