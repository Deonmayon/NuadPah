import { FastifyInstance, FastifyReply } from "fastify";
import { AuthForgetPWBodyRequest } from "../type/handler/auth";
import crypto from "crypto";
import { sendEmail } from "../util/nodemalier";

export const handleResendOTP = async (
  request: AuthForgetPWBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  const emailForget = request.body.email;
  const client = await app.pg.connect();
  const { rows } = await client.query(
    `
      SELECT * FROM public."User"
      WHERE email = $1;
    `,
    [emailForget]
  );

  if (rows.length == 1) {
    const otp = crypto.randomInt(100000, 999999).toString();
    const expiresAt = new Date(Date.now() + 1 * 60 * 1000); // (Date.now() + minute(s) * toMinute * toSec)
    console.log(expiresAt);
    const { rows } = await client.query(
      `
            INSERT INTO public."OTP" (email, otp, expired_at)
            VALUES ($1, $2, $3);
        `,
      [emailForget, otp, expiresAt]
    );

    await sendEmail(emailForget, `Your OTP is ${otp}.`);

    return reply.status(201).send({
      message: "OTP is already sent, Please check your Email",
    });
  }
};
