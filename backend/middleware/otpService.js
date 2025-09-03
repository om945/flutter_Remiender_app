import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 587,
  secure: false, // true for 465, false for other ports
  auth: {
    user: 'ombelekar21@gmail.com',
    pass: 'qtro nnvl zbry zctw',
  },
});

export { transporter };
