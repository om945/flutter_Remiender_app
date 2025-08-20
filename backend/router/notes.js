import express from 'express';
import {
  handleDeleteNote,
  handleEditNotes,
  handleGenerateNewNote,
  handleGetNotes,
} from '../controller/notes.js';
import auth from '../middleware/auth.js';

const router = express.Router();

router.post('/api/notes', auth, handleGenerateNewNote);
router.get('/api/notes', auth, handleGetNotes);
router.patch('/api/notes', auth, handleEditNotes);
router.delete('/api/notes', auth, handleDeleteNote);

export default router;
