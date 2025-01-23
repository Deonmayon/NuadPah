import { FastifyRequest } from "fastify";

export type sessionBodyRequest = FastifyRequest<{
  Body: {
    userEmail: string;
    userRole: string;
  };
}>;
