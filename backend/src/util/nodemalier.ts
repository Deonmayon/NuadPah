import nodemailer from "nodemailer";
import config from "../config/config";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: config.mail_user,
    pass: config.mail_pw,
  },
});

export const sendEmail = async (to: string, text: string) => {
  await transporter.sendMail({
    from: config.mail_user,
    to,
    subject: "OTP for Reset your Password, Please use this OTP within 1 minute",
    text,
  });
};
