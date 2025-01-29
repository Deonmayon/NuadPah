import { FastifyInstance, FastifyReply } from "fastify";
import { AddSingleMassageBodyRequest } from "../../../type/handler/admin";

export const handleAddSingleMassage = async (
  request: AddSingleMassageBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { mt_name, mt_type, mt_round, mt_time, mt_detail, mt_image_name } =
      request.body;

    const client = await app.pg.connect();
    const { rows } = await client.query(
      `
        INSERT INTO public."MassageTechnique"(
          mt_name, mt_type, mt_round, mt_time, mt_detail, mt_image_name
        )
        VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;
      `,
      [mt_name, mt_type, mt_round, mt_time, mt_detail, mt_image_name]
    );

    return reply
      .status(201)
      .send({ message: "Add Single Massage Successfully", data: rows[0] });
  } catch (err) {
    return reply.status(500).send({ error: "Can't Add Single Massage" });
  }
};
