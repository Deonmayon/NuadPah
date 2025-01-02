import { FastifyRequest } from "fastify";

export type AuthSignInBodyRequest = FastifyRequest<{
  Body: {
    email: string;
    password: string;
  };
}>;

export type AuthSignUpBodyRequest = FastifyRequest<{
  Body: {
    email: string;
    firstname: string;
    lastname: string;
    password: string;
  };
}>;
