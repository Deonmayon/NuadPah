import redis from "../redis";

export const setSession = async (
  sessionId: string,
  data: Record<string, any>,
  ttl: number
) => {
  await redis.set(sessionId, JSON.stringify(data), "EX", ttl);
};
