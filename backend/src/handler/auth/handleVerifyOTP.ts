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
        SELECT otp, expired_at FROM public."OTP"
        WHERE email = $1 ORDER BY expired_at DESC LIMIT 1;
      `,
      [email]
    );

    if (rowCount != 1) {
      return reply
        .status(404)
        .send({ error: "OTP does not exist", data: { verified: false } });
    }

    const latest_otp = rows[0].otp;
    const expired_at = rows[0].expired_at;

    const expiresAt = new Date(expired_at).getTime();
    const now = Date.now();
    const time_diff = expiresAt - now;
    const time_condition = true ? time_diff >= 0 : false;

    console.log("latest_otp:", latest_otp);
    console.log("expiresAt:", expiresAt);
    console.log("now:", now);
    console.log("time_diff:", time_diff);
    console.log("time_condition:", time_condition);
    console.log("otp_condition:", latest_otp != otp);

    if (latest_otp != otp || !time_condition) {
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
