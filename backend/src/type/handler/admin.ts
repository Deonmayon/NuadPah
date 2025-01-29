import { FastifyRequest } from "fastify";

// Massage Technique Management ////////////////////////////////////////////////////////////////

// Add Single Massage Technique
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

// Edit Single Massage Technique
export type EditSingleMassageBodyRequest = FastifyRequest<{
  Body: {
    mt_name: string;
    mt_type: string;
    mt_round: number;
    mt_time: number;
    mt_detail: string;
    mt_image_name: string;
  };
  Params: {
    mt_id: number;
  };
}>;

// Delete Single Massage Technique
export type DeleteSingleMassageParamsRequest = FastifyRequest<{
  Params: {
    mt_id: number;
  };
}>;

// Add Set Massage Technique
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

// Edit Set Massage Technique
export type EditSetMassageBodyRequest = FastifyRequest<{
  Body: {
    mt_ids: Array<number>;
    ms_name: string;
    ms_type: string;
    ms_time: number;
    ms_detail: string;
    ms_image_names: string[];
  };
  Params: {
    ms_id: number;
  };
}>;

// Delete Set Massage Technique
export type DeleteSetMassageParamsRequest = FastifyRequest<{
  Params: {
    ms_id: number;
  };
}>;
////////////////////////////////////////////////////////////////////////////////////////////////

// User Management /////////////////////////////////////////////////////////////////////////////

// Edit User Information
export type EditUserBodyRequest = FastifyRequest<{
  Body: {
    email: string;
    firstname: string;
    lastname: string;
    password: string;
    image_name: string;
  };
  Params: {
    id: number;
  };
}>;

// Delete User Account
export type DeleteUserParamsRequest = FastifyRequest<{
  Params: {
    id: number;
  };
}>;
////////////////////////////////////////////////////////////////////////////////////////////////

// Report Management /////////////////////////////////////////////////////////////////////////////

// Update Report Status
export type UpdateReportStatusBodyRequest = FastifyRequest<{
  Body: {
    status_index: number;
  };
  Params: {
    rep_id: number;
  };
}>;
////////////////////////////////////////////////////////////////////////////////////////////////