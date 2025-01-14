import { FastifyInstance, FastifyReply } from "fastify";
import {
  SingleMassageDetailBodyRequest,
  SetMassageDetailBodyRequest,
  ReviewSingleMassageBodyRequest,
  ReviewSetMassageBodyRequest,
} from "../type/handler/massage";
import { handleGetSingleDetail } from "../handler/massage/handleGetSingleDetail";

const massageRouter = async (app: FastifyInstance) => {
  app.post(
    "/single-detail",
    async (request: SingleMassageDetailBodyRequest, reply: FastifyReply) => {
      const result = await handleGetSingleDetail(request, reply, app);
      reply.send(result);
    }
  );
};

export default massageRouter;
