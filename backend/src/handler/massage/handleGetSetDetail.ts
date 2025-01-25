import { FastifyInstance, FastifyReply } from "fastify";
import { SetMassageDetailBodyRequest } from "../../type/handler/massage";

export const handleGetSetDetail = async (
  request: SetMassageDetailBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { ms_id } = request.body;
    const client = await app.pg.connect();
    const massageSetQuery = await client.query(
      `
        SELECT * FROM public."MassageSet"
        WHERE ms_id = $1;
      `,
      [ms_id]
    );

    if (massageSetQuery.rowCount < 1) {
      return reply
        .status(404)
        .send({ error: "This Single Massage Technique is not exist !" });
    }

    const massageSetDetail = massageSetQuery.rows[0];
    const mt_ids = massageSetDetail.mt_ids;
    let massageTechniques = [];
    for (let mt_id of mt_ids) {
      const massageQuery = await client.query(
        `
        SELECT * FROM public."MassageTechnique"
        WHERE mt_id = $1;
      `,
        [mt_id]
      );
      massageTechniques.push(massageQuery.rows[0]);
    }

    massageSetDetail.massageTechniqueDetails = massageTechniques;

    return reply.status(200).send({
      message: "Fetch Set Massage Technique Successfully",
      data: massageSetDetail,
    });
  } catch (err) {
    return reply
      .status(500)
      .send({ error: err, message: "Can't Find Single Massage Technique" });
  }
};
