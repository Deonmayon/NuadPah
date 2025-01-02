import fastify, { FastifyServerOptions } from "fastify";
import fastifyPostgres, { PostgresPluginOptions } from "@fastify/postgres";
import config from "./config/config";
import authRouter from "./router/auth";

const buildApp = (options: FastifyServerOptions) => {
  const app = fastify(options);

  const postgresOptions: PostgresPluginOptions = {
    connectionString: config.db,
  };
  app.register(fastifyPostgres, postgresOptions);

  app.register(authRouter, { prefix: "/auth" });

  app.setErrorHandler((error, request, reply) =>
    reply.status(error.statusCode || 500).send({
      error: {
        message: error.message,
        code: error.code,
      },
    })
  );

  return app;
};

export default buildApp;
