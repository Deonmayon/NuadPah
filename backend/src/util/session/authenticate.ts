import jwt from "jsonwebtoken";
import { getSession } from "./getSession";
import { FastifyReply } from "fastify";
import { sessionBodyRequest } from "../../type/session/sessionBodyRequest";
import config from "../../config/config";

export const authenticate = async (
  request: sessionBodyRequest,
  reply: FastifyReply,
  next: any
) => {
  const token = request.headers.authorization?.split(" ")[1];

  if (!token) {
    return reply.status(401).send({ error: "Missing token" });
  }

  try {
    const decoded: any = jwt.verify(token, config.jwt);

    const session = await getSession(decoded.userEmail);
    if (!session || session.status !== "active" || session.token !== token) {
      return reply.status(401).send({ error: "Invalid or expired session" });
    }

    request.body.userEmail = decoded.userEmail;
    next();
  } catch (err) {
    return reply.status(401).send({ error: "Invalid token" });
  }
};
