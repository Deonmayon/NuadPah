import { FastifyInstance, FastifyReply } from "fastify";

export const handleGetSetLists = async (
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const client = await app.pg.connect();
    const { rows, rowCount } = await client.query(
      `
        SELECT * FROM public."MassageSet";
      `
    );

    if (rowCount < 1) {
      return reply
        .status(404)
        .send({ error: "Any Set Massage Technique is not exist !" });
    }

    return reply.status(200).send({
      message: "Fetch Set Massage Techniques Successfully",
      data: rows,
    });
  } catch (err) {
    return reply
      .status(500)
      .send({ error: err, message: "Can't Find Set Massage Technique" });
  }
};
