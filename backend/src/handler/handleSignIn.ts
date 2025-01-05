import { FastifyInstance, FastifyReply } from "fastify";
import { verifyPassword } from "../util/bcrypt";
import { setSession } from "../util/session/setSession";
import { AuthSignInBodyRequest } from "../type/handler/auth";
import jwt from "jsonwebtoken";
import config from "../config/config";

export const handleSignIn = async (
  request: AuthSignInBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  const { email, password } = request.body;

  const client = await app.pg.connect();
  const { rows } = await client.query(
    `
      SELECT * FROM public."User"
      WHERE email = $1;
    `,
    [email]
  );

  if (rows.length == 1) {
    const hashedPW = rows[0].password;
    const isMatch = await verifyPassword(password, hashedPW);

    if (!isMatch) {
      return reply.status(400).send({ error: "Invalid email or password" });
    }

    const token = jwt.sign({ userEmail: rows[0].email }, config.jwt, {
      expiresIn: "15m",
    });

    await setSession(rows[0].email, { status: "active", token }, 3600); // 1 hour

    return reply.status(201).send({ token });
  }
};
