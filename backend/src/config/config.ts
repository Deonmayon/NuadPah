import * as dotenv from "dotenv";

dotenv.config();

const config = {
  env: process.env.NODE_ENV || "development",
  host: process.env.HOST || "localhost",
  port: process.env.PORT || 3000,
  db: process.env.DATABASE_URL,
  jwt: process.env.JWT_SECRET || "nuad_pah_comsci",
  mail_user: process.env.EMAIL_USER,
  mail_pw: process.env.EMAIL_PASSWORD,
};

export default config;
