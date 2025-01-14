import { FastifyInstance, FastifyReply } from "fastify";
import { GetSetMassageReviewsBodyRequest } from "../../type/handler/massage";

export const handleGetSetReviews = async (
  request: GetSetMassageReviewsBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { ms_id } = request.body;
    const client = await app.pg.connect();
    const { rows, rowCount } = await client.query(
      `
        SELECT * FROM public."ReviewSetMassage"
        WHERE ms_id = $1;
      `,
      [ms_id]
    );

    if (rowCount < 1) {
      return reply
        .status(404)
        .send({ error: "No Any Set Massage Technique's Reviews" });
    }

    return reply.status(200).send({
      message: "Fetch Set Massage Technique's Reviews Successfully",
      data: rows,
    });
  } catch (err) {
    return reply
      .status(500)
      .send({
        error: err,
        message: "Can't Fetch Set Massage Technique's Reviews",
      });
  }
};
