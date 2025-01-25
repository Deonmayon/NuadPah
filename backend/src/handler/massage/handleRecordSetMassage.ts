import { FastifyInstance, FastifyReply } from "fastify";
import { getStatus } from "../../util/learning_status";
import { RecordSetMassageBodyRequest } from "../../type/handler/massage";

export const handleRecordSetMassage = async (
  request: RecordSetMassageBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { email, ms_id, learning_round, learning_time, datetime } =
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
        WHERE ms_id = $1;
      `,
      [ms_id]
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
          ms_id, id, learning_time, learning_round, status, datetime
        )
        VALUES ($1, $2, $3, $4, $5) RETURNING *;
      `,
      [ms_id, id, learning_time, learning_round, status, datetime]
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
