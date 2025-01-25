import { FastifyInstance, FastifyReply } from "fastify";
import { getStatus } from "../../util/learning_status";
import { RecordSingleMassageBodyRequest } from "../../type/handler/massage";

export const handleRecordSingleMassage = async (
  request: RecordSingleMassageBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { email, mt_id, learning_round, learning_time, datetime } =
      request.body;
    const client = await app.pg.connect();
    const userQuery = await client.query(
      `
        SELECT id FROM public."User"
        WHERE email = $1;
      `,
      [email]
    );

    if (userQuery.rowCount < 1) {
      return reply
        .status(404)
        .send({ error: "There is no this User in system" });
    }

    const id = userQuery.rows[0].id;

    const massageQuery = await client.query(
      `
        SELECT * FROM public."MassageTechnique"
        WHERE mt_id = $1;
      `,
      [mt_id]
    );

    if (massageQuery.rowCount < 1) {
      return reply
        .status(404)
        .send({ error: "There is no this User in system" });
    }

    const timesup_condition = massageQuery.rows[0].mt_time;
    const round_condition = massageQuery.rows[0].mt_round;

    const status = getStatus(
      learning_time,
      learning_round,
      timesup_condition,
      round_condition
    );

    const { rows } = await client.query(
      `
        INSERT INTO public."SingleHistory"(
          mt_id, id, learning_time, learning_round, status, datetime
        )
        VALUES ($1, $2, $3, $4, $5) RETURNING *;
      `,
      [mt_id, id, learning_time, learning_round, status, datetime]
    );

    return reply.status(201).send({
      message: "Record Your Single Massage's Learning Successfully",
      data: rows[0],
    });
  } catch (err) {
    return reply.status(500).send({
      error: err,
      message: "Can't Record Your Single Massage's Learning",
    });
  }
};
