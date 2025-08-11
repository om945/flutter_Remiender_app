const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./router/auth');

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(authRouter);

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
