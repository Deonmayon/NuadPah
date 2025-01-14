import { FastifyInstance, FastifyReply } from "fastify";
import {
  AuthSignInBodyRequest,
  AuthSignUpBodyRequest,
  AuthForgetPWBodyRequest,
  AuthResetPWBodyRequest,
} from "../type/handler/auth";
import { sessionBodyRequest } from "../type/session/sessionBodyRequest";
import { handleSignIn } from "../handler/auth/handleSignIn";
import { handleSignUp } from "../handler/auth/handleSignUp";
import { handleForgetPW } from "../handler/auth/handleForgetPW";
import { handleResetPW } from "../handler/auth/handleResetPW";
import { deleteSession } from "../util/session/deleteSession";
import { authenticate } from "../util/session/authenticate";

const authRouter = async (app: FastifyInstance) => {
  app.post(
    "/signin",
    async (request: AuthSignInBodyRequest, reply: FastifyReply) => {
      const result = await handleSignIn(request, reply, app);
      reply.send(result);
    }
  );

  app.post(
    "/signup",
    async (request: AuthSignUpBodyRequest, reply: FastifyReply) => {
      const result = await handleSignUp(request, reply, app);
      reply.send(result);
    }
  );

  app.post(
    "/signout",
    { preHandler: [authenticate] },
    async (request: sessionBodyRequest, reply) => {
      await deleteSession(request.body.userEmail);
      reply.send({ message: "Signed out successfully" });
    }
  );

  app.post(
    "/forgetpw",
    async (request: AuthForgetPWBodyRequest, reply: FastifyReply) => {
      const result = await handleForgetPW(request, reply, app);
      reply.send(result);
    }
  );

  app.post(
    "/resetpw",
    async (request: AuthResetPWBodyRequest, reply: FastifyReply) => {
      const result = await handleResetPW(request, reply, app);
      reply.send(result);
    }
  );

  // Get User's data
  app.post(
    "/userdata",
    { preHandler: [authenticate] },
    async (request: sessionBodyRequest, reply) => {
      reply.send({
        message: "This is your user data",
        user: request.body.userEmail,
      });
    }
  );
};

export default authRouter;
