import express, { Router } from 'express';
import handleGenerateNewNote from '../controller/notes.js';
import auth from '../middleware/auth.js';

const router = express.Router();

router.post('/api/notes', auth, handleGenerateNewNote);

export default router;
