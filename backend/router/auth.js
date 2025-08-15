import express from 'express';
import bcryptjs from 'bcryptjs';
import User from '../models/user.js';
import jwt from 'jsonwebtoken';
import auth from '../middleware/auth.js';

const authRouter = express.Router();

//Sign Up
authRouter.post('/api/signup', async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: 'User with this email already exist!' });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//Sign In
authRouter.post('/api/signin', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: 'User with is email does not exist!' });
    }
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: 'Incorrrect username or password' });
    }
    const token = jwt.sign({ id: user._id }, 'passwordKey');
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//validate token
authRouter.post('/api/tokenIsValid', async (req, res) => {
  try {
    const token = req.header('x-auth-token');
    if (!token) return res.json(false);

    const verified = jwt.verify(token, 'passwordKey');
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//get user data
authRouter.get('/api/user', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }
    res.json({ ...user._doc, token: req.token });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

export default authRouter;
