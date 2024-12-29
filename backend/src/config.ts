import * as dotenv from "dotenv";

dotenv.config();

const config = {
  env: process.env.NODE_ENV || "development",
  host: process.env.HOST || "localhost",
  port: process.env.PORT || 3000,
  db: process.env.DATABASE_URL,
};

export default config;
