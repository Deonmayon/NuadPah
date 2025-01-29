import { FastifyInstance, FastifyReply } from "fastify";
import { SendReportStatusBodyRequest } from "../type/handler/support";
import { handleSendReport } from "../handler/support/handleSendReport";

const supportRouter = async (app: FastifyInstance) => {
  // User Send Report
  app.post(
    "/send-report",
    async (request: SendReportStatusBodyRequest, reply: FastifyReply) => {
      const result = await handleSendReport(request, reply, app);
      reply.send(result);
    }
  );
};

export default supportRouter;
