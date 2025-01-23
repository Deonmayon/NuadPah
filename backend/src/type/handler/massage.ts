import { FastifyRequest } from "fastify";

export type SingleMassageDetailBodyRequest = FastifyRequest<{
  Body: {
    mt_id: number;
  };
}>;

export type SetMassageDetailBodyRequest = FastifyRequest<{
  Body: {
    ms_id: number;
  };
}>;

export type GetSingleMassageReviewsBodyRequest = FastifyRequest<{
  Body: {
    mt_id: number;
  };
}>;

export type GetSetMassageReviewsBodyRequest = FastifyRequest<{
  Body: {
    ms_id: number;
  };
}>;

export type ReviewSingleMassageBodyRequest = FastifyRequest<{
  Body: {
    email: string; // Recieve Email for query id, then add review with id of Current User
    mt_id: number;
    rating: number;
    detail: string;
    datetime: string; // Use string for convert to ISO string later;
  };
}>;

export type ReviewSetMassageBodyRequest = FastifyRequest<{
  Body: {
    email: string; // Recieve Email for query id, then add review with id of Current User
    ms_id: number;
    rating: number;
    detail: string;
    datetime: string; // Use string for convert to ISO string later;
  };
}>;

export type RecordSingleMassageBodyRequest = FastifyRequest<{
  Body: {
    email: string; // Recieve Email for query id, then add review with id of Current User
    mt_id: number;
    learning_round: number;
    learning_time: number;
    datetime: string; // Use string for convert to ISO string later;
  };
}>;

export type RecordSetMassageBodyRequest = FastifyRequest<{
  Body: {
    email: string; // Recieve Email for query id, then add review with id of Current User
    ms_id: number;
    learning_round: number;
    learning_time: number;
    datetime: string; // Use string for convert to ISO string later;
  };
}>;