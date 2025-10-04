import {
  Reset_Password_Email_Template,
  Verification_Email_Template,
} from './emailTemplate.js';
import { transporter } from './otpService.js';

async function sendVerificationCode(email, verificationCode) {
  try {
    const response = await transporter.sendMail({
      from: '"PlanPad" <ombelekar21@gmail.com>',
      to: email,
      subject: 'Email verification',
      text: 'Verify your mail',
      html: Verification_Email_Template.replace(
        '{verificationCode}',
        verificationCode
      ),
    });
    console.log('email send successfully', response);
  } catch (error) {
    console.log(error);
  }
}

async function sendPasswordResetOtp(email, otpCode) {
  try {
    const response = await transporter.sendMail({
      from: '"PlanPad" <ombelekar21@gmail.com>',
      to: email,
      subject: 'Password Reset OTP',
      html: Reset_Password_Email_Template.replace('{otpCode}', otpCode),
    });
    console.log('Password reset OTP email sent successfully', response);
  } catch (error) {
    console.log(error);
  }
}

export { sendVerificationCode, sendPasswordResetOtp };
