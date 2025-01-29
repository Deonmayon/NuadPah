import { FastifyRequest } from "fastify";

// Report Management /////////////////////////////////////////////////////////////////////////////

// Update Report Status
export type SendReportStatusBodyRequest = FastifyRequest<{
  Body: {
    email: string; // for query User ID later
    title: string;
    detail: string;
    timestamp: string; // Use string for convert to ISO string later
  };
}>;
////////////////////////////////////////////////////////////////////////////////////////////////