package config

import (
	"context"

	"github.com/go-redis/redis/v8"
)

var RedisClient *redis.Client
var Ctx = context.Background()

func InitRedis() *redis.Client {
	RedisClient = redis.NewClient(&redis.Options{
		Addr: "localhost:6379",
	})
	return RedisClient
}
