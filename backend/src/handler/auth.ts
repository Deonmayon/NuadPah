import { FastifyInstance, FastifyReply } from "fastify";
import { hashPassword, verifyPassword } from ".././bcrypt";
import {
  AuthSignInBodyRequest,
  AuthSignUpBodyRequest,
} from "../type/handler/auth";

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

    return rows[0];
  }
};

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
          email, firstname, lastname, password, image_name
        ) VALUES ('$1', '$2', '$3', '$4', 'user_icon');
      `,
      [email, firstname, lastname, hashedPW]
    );

    return reply.status(201);
  }
};

export default {
  handleSignIn,
  handleSignUp,
};
