import { FastifyInstance, FastifyReply } from "fastify";
import {
  AddSingleMassageBodyRequest,
  AddSetMassageBodyRequest,
} from "../type/handler/admin";
import { handleAddSingleMassage } from "../handler/admin/handleAddSingleMassage";
import { handleAddSetMassage } from "../handler/admin/handleAddSetMassage";

const adminRouter = async (app: FastifyInstance) => {
  app.post(
    "/add-single-massage",
    async (request: AddSingleMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleAddSingleMassage(request, reply, app);
      reply.send(result);
    }
  );
  app.post(
    "/add-set-massage",
    async (request: AddSetMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleAddSetMassage(request, reply, app);
      reply.send(result);
    }
  );
};

export default adminRouter;
