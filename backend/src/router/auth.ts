import { FastifyInstance, FastifyReply } from "fastify";
import { handleSignIn } from "../handler/auth";
import { AuthSignInBodyRequest } from "../type/handler/auth";

const authRouter = async (app: FastifyInstance) => {
  app.post(
    "/login",
    async (request: AuthSignInBodyRequest, reply: FastifyReply) => {
      const result = await handleSignIn(request, reply, app);
      reply.send(result);
    }
  );
};

export default authRouter;
