import { FastifyInstance, FastifyReply } from "fastify";
import { UpdateReportStatusBodyRequest } from "../../../type/handler/admin";

export const handleUpdateReportStatus = async (
  request: UpdateReportStatusBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { rep_id } = request.params;
    const { status_index } = request.body;
    // status_index:
    // 0 = Pending
    // 1 = Processing
    // 2 = Completed
    // 3 = Cancelled

    const status = ["Pending", "Processing", "Completed", "Cancelled"];

    const client = await app.pg.connect();
    const { rows } = await client.query(
      `
        UPDATE public."Report"
        SET status = $1
        WHERE rep_id = $2 RETURNING *;
      `,
      [status[status_index], rep_id]
    );

    return reply
      .status(200)
      .send({ message: "Update Report Status Successfully", data: rows[0] });
  } catch (err) {
    return reply.status(500).send({ error: "Can't Update Report Status" });
  }
};
