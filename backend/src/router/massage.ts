import { FastifyInstance, FastifyReply } from "fastify";
import {
  SingleMassageDetailBodyRequest,
  SetMassageDetailBodyRequest,
  GetSingleMassageReviewsBodyRequest,
  GetSetMassageReviewsBodyRequest,
  ReviewSingleMassageBodyRequest,
  ReviewSetMassageBodyRequest,
  RecordSingleMassageBodyRequest,
  RecordSetMassageBodyRequest,
} from "../type/handler/massage";
import { handleGetSingleDetail } from "../handler/massage/handleGetSingleDetail";
import { handleGetSetDetail } from "../handler/massage/handleGetSetDetail";
import { handleGetSingleReviews } from "../handler/massage/handleGetSingleReviews";
import { handleGetSetReviews } from "../handler/massage/handleGetSetReviews";
import { handleReviewSingleMassage } from "../handler/massage/handleReviewSingleMassage";
import { handleReviewSetMassage } from "../handler/massage/handleReviewSetMassage";
import { handleRecordSingleMassage } from "../handler/massage/handleRecordSingleMassage";
import { handleRecordSetMassage } from "../handler/massage/handleRecordSetMassage";

const massageRouter = async (app: FastifyInstance) => {
  app.post(
    "/single-detail",
    async (request: SingleMassageDetailBodyRequest, reply: FastifyReply) => {
      const result = await handleGetSingleDetail(request, reply, app);
      reply.send(result);
    }
  );
  app.post(
    "/set-detail",
    async (request: SetMassageDetailBodyRequest, reply: FastifyReply) => {
      const result = await handleGetSetDetail(request, reply, app);
      reply.send(result);
    }
  );
  app.post(
    "/single-reviews",
    async (
      request: GetSingleMassageReviewsBodyRequest,
      reply: FastifyReply
    ) => {
      const result = await handleGetSingleReviews(request, reply, app);
      reply.send(result);
    }
  );
  app.post(
    "/set-reviews",
    async (request: GetSetMassageReviewsBodyRequest, reply: FastifyReply) => {
      const result = await handleGetSetReviews(request, reply, app);
      reply.send(result);
    }
  );
  app.post(
    "/review-single",
    async (request: ReviewSingleMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleReviewSingleMassage(request, reply, app);
      reply.send(result);
    }
  );
  app.post(
    "/review-set",
    async (request: ReviewSetMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleReviewSetMassage(request, reply, app);
      reply.send(result);
    }
  );
  app.post(
    "/record-single",
    async (request: RecordSingleMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleRecordSingleMassage(request, reply, app);
      reply.send(result);
    }
  );
  app.post(
    "/record-set",
    async (request: RecordSetMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleRecordSetMassage(request, reply, app);
      reply.send(result);
    }
  );
};

export default massageRouter;
