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

const sendEmail = async () => {
  try {
    const info = await transporter.sendMail({
      from: '"Bankai" <ombelekar21@gmail.com>',
      to: 'ombelekar21@gmail.com',
      subject: 'Hinokamikagura',
      text: 'Hello world?', // plain‑text body
      html: '<b>Hello world?</b>', // HTML body
    });
    console.log(info);
  } catch (error) {
    console.log(error);
  }
};

export { transporter, sendEmail };
