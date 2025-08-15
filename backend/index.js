import express from 'express';
import mongoose from 'mongoose';
import authRouter from './router/auth.js';
import notesRouter from './router/notes.js';

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(authRouter);
app.use(notesRouter);

const DB =
  'mongodb+srv://ombelekar21:IeIUBVCUzyWRtKPl@cluster0.cpoc2p2.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose
  .connect(DB)
  .then(() => {
    console.log('mongoose connected');
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, '0.0.0.0', () => {
  console.log(`server started app port ${PORT}`);
});
