import express, { Router } from 'express';
import { handleGenerateNewNote, handleGetNotes } from '../controller/notes.js';
import auth from '../middleware/auth.js';

const router = express.Router();

router.post('/api/notes', auth, handleGenerateNewNote);
router.get('/api/notes', auth, handleGetNotes);

export default router;
