import { FastifyInstance, FastifyReply } from "fastify";
import { ReviewSetMassageBodyRequest } from "../../type/handler/massage";

export const handleReviewSetMassage = async (
  request: ReviewSetMassageBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { email, ms_id, rating, detail, datetime } = request.body;
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

    const { rows } = await client.query(
      `
        INSERT INTO public."ReviewSetMassage"(
          ms_id, id, rating, detail, datetime
        )
        VALUES ($1, $2, $3, $4, $5) RETURNING *;
      `,
      [ms_id, id, rating, detail, datetime]
    );

    return reply.status(201).send({
      message: "Add Your Set Massage's Review Successfully",
      data: rows[0],
    });
  } catch (err) {
    return reply
      .status(500)
      .send({ error: err, message: "Can't Add Your Set Massage's Review" });
  }
};
