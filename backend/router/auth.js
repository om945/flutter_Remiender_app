import express from 'express';
import bcryptjs from 'bcryptjs';
import User from '../models/user.js';
import jwt from 'jsonwebtoken';
import auth from '../middleware/auth.js';
import { sendVerificationCode } from '../middleware/email.js';
import {
  handleGetUserData,
  handleSignIn,
  handleSignUp,
  handleTokenValidation,
  verifyEmail,
  handleForgotPasswordRequest,
  handleResetPasswordWithOtp,
  handleVerifyResetOtp,
} from '../controller/auth.js';

const authRouter = express.Router();

//Sign Up
authRouter.post('/api/signup', handleSignUp);
//Sign In
authRouter.post('/api/signin', handleSignIn);
//validate token
authRouter.post('/api/tokenIsValid', handleTokenValidation);
//get user data
authRouter.get('/api/user', auth, handleGetUserData);

authRouter.post('/api/verification', verifyEmail);

authRouter.post('/api/forgot-password', handleForgotPasswordRequest);
authRouter.post('/api/reset-password', handleResetPasswordWithOtp);
authRouter.post('/api/verify-reset-otp', handleVerifyResetOtp);

// authRouter.post('/api/reverification', handleReverificationRequest);

export default authRouter;
