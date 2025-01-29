import { FastifyInstance, FastifyReply } from "fastify";
import { DeleteUserParamsRequest } from "../../../type/handler/admin";

export const handleUserDelete = async (
  request: DeleteUserParamsRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { id } = request.params;
    const client = await app.pg.connect();
    const { rows } = await client.query(
      `
        DELETE FROM public."User"
	    WHERE id = $1 RETURNING *;
      `,
      [id]
    );
    return reply.status(200).send({
      message: "Delete this User Account Successfully",
      data: rows[0],
    });
  } catch (err) {
    return reply.status(500).send({ error: "Can't Delete this User Account" });
  }
};
