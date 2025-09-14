import express from 'express';
import {
  handleDeletetodos,
  handleEditTodos,
  handleGenerateNewTodos,
  handleGetTodos,
  handleUpdateTodoCompletionStatus,
} from '../controller/todo.js';
import auth from '../middleware/auth.js';

const router = express.Router();

router.post('/api/todo', auth, handleGenerateNewTodos);
router.get('/api/todo', auth, handleGetTodos);
router.patch('/api/todo/:id', auth, handleEditTodos);
router.delete('/api/todo', auth, handleDeletetodos);
router.patch('/api/todo/:id/complete', auth, handleUpdateTodoCompletionStatus);

export default router;
