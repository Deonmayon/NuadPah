import { FastifyInstance, FastifyReply } from "fastify";
import { EditSingleMassageBodyRequest } from "../../../type/handler/admin";

export const handleEditSingleMassage = async (
  request: EditSingleMassageBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { mt_id } = request.params;
    const { mt_name, mt_type, mt_round, mt_time, mt_detail, mt_image_name } =
      request.body;

    const client = await app.pg.connect();
    const { rows } = await client.query(
      `
        UPDATE public."MassageTechnique"
        SET mt_name = $1, mt_type = $2, mt_round = $3, mt_time = $4, mt_detail = $5, mt_image_name = $6
        WHERE mt_id = $7 RETURNING *;
      `,
      [mt_name, mt_type, mt_round, mt_time, mt_detail, mt_image_name, mt_id]
    );

    return reply
      .status(200)
      .send({ message: "Edit Single Massage Successfully", data: rows[0] });
  } catch (err) {
    return reply.status(500).send({ error: "Can't Edit Single Massage" });
  }
};
