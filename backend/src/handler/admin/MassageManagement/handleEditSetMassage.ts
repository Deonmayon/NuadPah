import { FastifyInstance, FastifyReply } from "fastify";
import { EditSetMassageBodyRequest } from "../../../type/handler/admin";

export const handleEditSetMassage = async (
  request: EditSetMassageBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { ms_id } = request.params;
    const { mt_ids, ms_name, ms_type, ms_time, ms_detail, ms_image_names } =
      request.body;

    const client = await app.pg.connect();
    const { rows } = await client.query(
      `
        UPDATE public."MassageSet"
        SET mt_ids = $1, ms_name = $2, ms_type = $3, ms_time = $4, ms_detail = $5, ms_image_names = $6
        WHERE ms_id = $7 RETURNING *;
      `,
      [mt_ids, ms_name, ms_type, ms_time, ms_detail, ms_image_names, ms_id]
    );

    return reply
      .status(200)
      .send({ message: "Edit Set Massage Successfully", data: rows[0] });
  } catch (err) {
    return reply.status(500).send({ error: "Can't Edit Set Massage" });
  }
};
