import bcryptjs from 'bcryptjs';
import User from '../models/user.js';
import jwt from 'jsonwebtoken';
import auth from '../middleware/auth.js';
import { sendVerificationCode } from '../middleware/email.js';

async function handleSignUp(req, res) {
  try {
    const { name, email, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: 'User with this email already exist!' });
    }
    const hashedPassword = await bcryptjs.hash(password, 8);
    const verificationCode = Math.floor(
      100000 + Math.random() * 900000
    ).toString();

    let user = new User({
      email,
      password: hashedPassword,
      name,
      verificationCode,
    });
    user = await user.save();
    sendVerificationCode(user.email, verificationCode);
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

async function handleSignIn(rq, res) {
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
}

async function handleTokenValidation(req, res) {
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
}

async function handleGetUserData(req, res) {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }
    res.json({ ...user._doc, token: req.token });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

export { handleGetUserData, handleSignUp, handleSignIn, handleTokenValidation };
