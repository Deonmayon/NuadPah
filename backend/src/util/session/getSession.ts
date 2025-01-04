import redis from "../redis";

export const getSession = async (sessionId: string): Promise<any | null> => {
  const data = await redis.get(sessionId);
  return data ? JSON.parse(data) : null;
};
