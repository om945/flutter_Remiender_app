import express from 'express';
import mongoose from 'mongoose';
import authRouter from './router/auth.js';
import notesRouter from './router/notes.js';
import todoRouter from './router/todos.js';
import dotenv from 'dotenv';
dotenv.config();

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(authRouter);
app.use(notesRouter);
app.use(todoRouter);

mongoose
  .connect(process.env.MONGO_URI)
  .then(() => {
    console.log('mongoose connected');
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, '0.0.0.0', () => {
  console.log(`server started at port ${PORT}`);
});
