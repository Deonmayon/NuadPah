import { FastifyInstance, FastifyReply } from "fastify";
import { EditUserBodyRequest } from "../../../type/handler/admin";

export const handleUserEdit = async (
  request: EditUserBodyRequest,
  reply: FastifyReply,
  app: FastifyInstance
) => {
  try {
    const { id } = request.params;
    const { email, firstname, lastname, password, image_name } = request.body;

    const client = await app.pg.connect();
    const { rows } = await client.query(
      `
        UPDATE public."User"
        SET email = $1, firstname = $2, lastname = $3, password = $4, image_name = $5
        WHERE id = $5; RETURNING *;
      `,
      [email, firstname, lastname, password, image_name, id]
    );

    return reply
      .status(200)
      .send({ message: "Edit User Information Successfully", data: rows[0] });
  } catch (err) {
    return reply.status(500).send({ error: "Can't Edit Single Massage" });
  }
};
