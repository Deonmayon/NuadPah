import { FastifyInstance, FastifyReply } from "fastify";
import {
  AddSingleMassageBodyRequest,
  AddSetMassageBodyRequest,
  EditSingleMassageBodyRequest,
  EditSetMassageBodyRequest,
} from "../type/handler/admin";
import { handleAddSingleMassage } from "../handler/admin/handleAddSingleMassage";
import { handleAddSetMassage } from "../handler/admin/handleAddSetMassage";
import { handleEditSingleMassage } from "../handler/admin/handleEditSingleMassage";
import { handleEditSetMassage } from "../handler/admin/handleEditSetMassage";
import { handleDeleteSingleMassage } from "../handler/admin/handleDeleteSingleMassage";
import { handleDeleteSetMassage } from "../handler/admin/handleDeleteSetMassage";

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
  app.put(
    "/edit-single-massage/:mt_id",
    async (request: EditSingleMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleEditSingleMassage(request, reply, app);
      reply.send(result);
    }
  );
  app.put(
    "/edit-set-massage/:ms_id",
    async (request: EditSetMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleEditSetMassage(request, reply, app);
      reply.send(result);
    }
  );
  app.delete(
    "/delete-single-massage/:mt_id",
    async (request: EditSingleMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleDeleteSingleMassage(request, reply, app);
      reply.send(result);
    }
  );
  app.delete(
    "/delete-set-massage/:ms_id",
    async (request: EditSetMassageBodyRequest, reply: FastifyReply) => {
      const result = await handleDeleteSetMassage(request, reply, app);
      reply.send(result);
    }
  );
};

export default adminRouter;
