import jwt from "jsonwebtoken";
import { FastifyInstance, FastifyReply } from "fastify";
import { hashPassword } from "../util/bcrypt";
import { setSession } from "../util/session/setSession";
import { AuthSignUpBodyRequest } from "../type/handler/auth";
import config from "../config/config";

export const handleSignUp = async (
  request: AuthSignUpBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  const { email, firstname, lastname, password } = request.body;

  const client = await app.pg.connect();
  const { rows } = await client.query(
    `
      SELECT * FROM public."User"
      WHERE email = $1;
    `,
    [email]
  );

  if (rows.length > 0) {
    return reply.status(403).send({ error: "Already has this user" });
  } else {
    const hashedPW = await hashPassword(password);
    const { rows } = await client.query(
      `
        INSERT INTO public."User"(
          email, firstname, lastname, password, image_name, role
        ) VALUES ($1, $2, $3, $4, 'user_icon', 'user') RETURNING *;
      `,
      [email, firstname, lastname, hashedPW]
    );

    const token = jwt.sign({ userEmail: rows[0].email }, config.jwt, {
      expiresIn: "1h",
    });

    await setSession(rows[0].email, { status: "active", token }, 3600); // 1 hour

    return reply.status(201).send({ token });
  }
};
