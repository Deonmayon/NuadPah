import Redis from "ioredis";
import { spawn } from "child_process";
import path from "path";
import config from "../config/config";

const redisServerPath = path.resolve("C:\\Redis", "redis-server.exe");

const startRedis = () => {
  const redisServer = spawn(redisServerPath);

  redisServer.stdout.on("data", (data) => {
    console.log(`Redis: ${data.toString()}`);
  });

  redisServer.stderr.on("data", (data) => {
    console.error(`Redis Error: ${data.toString()}`);
  });

  redisServer.on("close", (code) => {
    console.log(`Redis server exited with code ${code}`);
  });
};

startRedis();

const redis = new Redis({
  host: config.host || "127.0.0.1",
  port: 6379,
});

redis.on("connect", () => {
  console.log("Redis connected successfully");
});

redis.on("error", (err) => {
  console.error("Redis connection error:", err);
});

export default redis;
