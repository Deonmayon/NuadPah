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
    role: string;
  };
}>;

export type AuthForgetPWBodyRequest = FastifyRequest<{
  Body: {
    email: string;
  };
}>;

export type AuthResetPWBodyRequest = FastifyRequest<{
  Body: {
    email: string;
    newpw: string;
    confirmpw: string;
  };
}>;
