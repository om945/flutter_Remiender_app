import express, { Router } from 'express';
import handleGenerateNewNote from '../controller/notes.js';

const router = express.Router();

router.post('/api/notes', handleGenerateNewNote);

export default router;
