import bcryptjs from 'bcryptjs';
import User from '../models/user.js';
import jwt from 'jsonwebtoken';
import {
  sendPasswordResetOtp,
  sendVerificationCode,
} from '../middleware/email.js';

async function handleSignUp(req, res) {
  try {
    const { name, email, password } = req.body;

    if (!password || password.length < 8) {
      return res
        .status(400)
        .json({ msg: 'Password must be at least 8 characters long.' });
    }

    // Regex to check for at least one letter and one number
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d).{8,}$/;
    if (!passwordRegex.test(password)) {
      return res.status(400).json({
        msg: 'Password must contain at least one letter and one number.',
      });
    }

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
    console.log('Signup Verification Code:', verificationCode);
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

async function handleSignIn(req, res) {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    const isVerify = await user.isVerify;
    if (isVerify == false) {
      return res.status(400).json({ msg: 'User is not verified' });
    }
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

async function verifyEmail(req, res) {
  try {
    const { code, email } = req.body;
    const user = await User.findOne({ verificationCode: code, email: email });

    if (!user) {
      return res.status(404).json({ msg: 'Invalid or Expired code' });
    }

    user.isVerify = true;
    user.verificationCode = undefined;

    await user.save();
    return res.status(200).json({ msg: 'Email verify successfully' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

async function handleForgotPasswordRequest(req, res) {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(404)
        .json({ msg: 'User with this email does not exist!' });
    }

    const resetPasswordOtp = Math.floor(
      100000 + Math.random() * 900000
    ).toString();
    user.resetPasswordOtp = resetPasswordOtp;
    user.resetPasswordOtpExpires = Date.now() + 3600000; // 1 hour
    await user.save();
    console.log('Forgot Password OTP:', resetPasswordOtp);
    console.log('OTP Expires At:', user.resetPasswordOtpExpires);

    sendPasswordResetOtp(user.email, resetPasswordOtp);

    res.status(200).json({ msg: 'Password reset OTP sent to your email.' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

async function handleResetPasswordWithOtp(req, res) {
  try {
    const { email, otp, newPassword } = req.body;
    console.log('Received Email:', email);
    console.log('Received OTP:', otp);
    console.log('Received New Password:', newPassword);

    const user = await User.findOne({ email });
    if (!user) {
      console.log('User not found for email:', email);
      return res
        .status(400)
        .json({ msg: 'User with this email does not exist.' });
    }
    console.log('Stored OTP:', user.resetPasswordOtp);
    console.log('Stored OTP Expires At:', user.resetPasswordOtpExpires);

    if (
      user.resetPasswordOtp !== otp ||
      user.resetPasswordOtpExpires < Date.now()
    ) {
      console.log('OTP mismatch or expired.');
      return res.status(400).json({ msg: 'Invalid or expired OTP.' });
    }

    const hashedPassword = await bcryptjs.hash(newPassword, 8);
    user.password = hashedPassword;
    user.resetPasswordOtp = undefined; // Clear the OTP
    user.resetPasswordOtpExpires = undefined; // Clear the OTP expiration
    await user.save();

    res.status(200).json({ msg: 'Password reset successfully.' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

async function handleVerifyResetOtp(req, res) {
  try {
    const { email, otp } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: 'User with this email does not exist.' });
    }

    if (
      user.resetPasswordOtp !== otp ||
      user.resetPasswordOtpExpires < Date.now()
    ) {
      return res.status(400).json({ msg: 'Invalid or expired OTP.' });
    }

    res.status(200).json({ msg: 'OTP verified successfully.' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

async function handleResendVerificationCode(req, res) {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(404)
        .json({ msg: 'User with this email does not exist!' });
    }

    if (user.isVerify) {
      return res.status(400).json({ msg: 'This account is already verified.' });
    }

    const verificationCode = Math.floor(
      100000 + Math.random() * 900000
    ).toString();
    user.verificationCode = verificationCode;
    await user.save();

    sendVerificationCode(user.email, verificationCode);
    res.status(200).json({ msg: 'A new verification code has been sent.' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

export {
  handleGetUserData,
  handleSignUp,
  handleSignIn,
  handleTokenValidation,
  verifyEmail,
  handleForgotPasswordRequest,
  handleResetPasswordWithOtp,
  handleVerifyResetOtp,
  handleResendVerificationCode,
};
