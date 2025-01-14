import { FastifyRequest } from "fastify";

export type AddSingleMassageBodyRequest = FastifyRequest<{
  Body: {
    mt_name: string;
    mt_type: string;
    mt_round: number;
    mt_time: number;
    mt_detail: string;
    mt_image_name: string;
  };
}>;

export type AddSetMassageBodyRequest = FastifyRequest<{
  Body: {
    mt_ids: Array<number>;
    ms_name: string;
    ms_type: string;
    ms_time: number;
    ms_detail: string;
    ms_image_names: string[];
  };
}>;
