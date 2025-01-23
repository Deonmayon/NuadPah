import { FastifyInstance, FastifyReply } from "fastify";
import { VerifyOTPBodyRequest } from "../../type/handler/auth";
import { log } from "console";

export const handleVerifyOTP = async (
  request: VerifyOTPBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { email, otp } = request.body;
    const client = await app.pg.connect();
    const { rows, rowCount } = await client.query(
      `
      SELECT expired_at FROM public."OTP"
      WHERE email = $1 AND otp = $2 LIMIT 1;
    `,
      [email, otp]
    );

    if (rowCount != 1) {
      return reply
        .status(404)
        .send({ error: "OTP does not exist", data: { verified: false } });
    }

    const expired_at = rows[0].expired_at;

    const expiresAt = new Date(expired_at).getTime();
    const now = Date.now();
    const time_diff = expiresAt - now;
    const time_condition = true ? time_diff >= 0 : false;

    if (!time_condition) {
      return reply
        .status(400)
        .send({ error: "Invalid OTP from backend", data: { verified: false } });
    }

    return reply.status(200).send({
      message: "Correct OTP",
      data: { verified: true },
    });
  } catch (err) {
    console.error("Error querying expired_at:", err);

    return reply.status(500).send({ error: "Database query failed" });
  }
};
