import { FastifyInstance, FastifyReply } from "fastify";

export const handleGetSingleLists = async (
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const client = await app.pg.connect();
    const { rows, rowCount } = await client.query(
      `
        SELECT * FROM public."MassageTechnique";
      `
    );

    if (rowCount < 1) {
      return reply
        .status(404)
        .send({ error: "Any Single Massage Technique is not exist !" });
    }

    return reply.status(200).send({
      message: "Fetch Single Massage Techniques Successfully",
      data: rows,
    });
  } catch (err) {
    return reply
      .status(500)
      .send({ error: err, message: "Can't Find Single Massage Technique" });
  }
};
