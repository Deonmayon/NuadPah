import { FastifyInstance, FastifyReply } from "fastify";
import {
  AuthSignInBodyRequest,
  AuthSignUpBodyRequest,
} from "../type/handler/auth";
import { handleSignIn } from "../handler/handleSignIn";
import { handleSignUp } from "../handler/handleSignUp";

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
};

export default authRouter;
