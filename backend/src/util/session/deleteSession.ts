import redis from "../redis";

export const deleteSession = async (sessionId: string) => {
  await redis.del(sessionId);
};
