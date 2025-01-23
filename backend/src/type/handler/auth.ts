import { FastifyRequest } from "fastify";

// for Sign In when press the button
export type AuthSignInBodyRequest = FastifyRequest<{
  Body: {
    email: string;
    password: string;
  };
}>;

// for Sign Up when press the button
export type AuthSignUpBodyRequest = FastifyRequest<{
  Body: {
    email: string;
    firstname: string;
    lastname: string;
    password: string;
    role: string;
  };
}>;

// for forget.dart when fill an email and submit
export type AuthForgetPWBodyRequest = FastifyRequest<{
  Body: {
    email: string;
  };
}>;

// for otp.dart when fill an otp and submit
export type VerifyOTPBodyRequest = FastifyRequest<{
  Body: {
    email: string; // email that pass between pages and send via the VerifyOTP api
    otp: string; // otp that user fill in the form
  };
}>;

// for forget.dart when fill an email and submit
export type AuthResetPWBodyRequest = FastifyRequest<{
  Body: {
    email: string; // email that pass between pages and send via the VerifyOTP api
    newpw: string;
    confirmpw: string;
  };
}>;
