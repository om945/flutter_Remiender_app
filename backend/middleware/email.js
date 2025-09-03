import { Verification_Email_Template } from './emailTemplate.js';
import { transporter } from './otpService.js';

async function sendVerificationCode(email, verificationCode) {
  try {
    const response = await transporter.sendMail({
      from: '"Bankai" <ombelekar21@gmail.com>',
      to: email,
      subject: 'Email verification',
      text: 'Verify your mail', // plain‑text body
      html: Verification_Email_Template.replace(
        '{verificationCode}',
        verificationCode
      ), // HTML body
    });
    console.log('email send successfully', response);
  } catch (error) {
    console.log(error);
  }
}

export { sendVerificationCode };
