import { FastifyInstance, FastifyReply } from "fastify";
import { SendReportStatusBodyRequest } from "../../type/handler/support";

export const handleSendReport = async (
  request: SendReportStatusBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    
    const { email, title, detail, timestamp } = request.body;

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

    const reportQuery = await client.query(
      `
        INSERT INTO public."Report"(
        id, title, detail, datetime, status)
        VALUES ($1, $2, $3, $4, 'Pending') RETURNING *;
      `,
      [id, title, detail, timestamp]
    );

    return reply
      .status(201)
      .send({
        message: "Send your Report Successfully",
        data: reportQuery.rows[0],
      });
  } catch (err) {
    return reply.status(500).send({ error: "Can't Send your Report" });
  }
};
