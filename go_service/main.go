package main

import (
	"goservice/config"
	"goservice/models"
	"goservice/routes"
	"goservice/workers"

	"github.com/gin-gonic/gin"
)

func main() {
	// Initialize database, redis, and elasticsearch
	db := config.InitDB()
	rdb := config.InitRedis()

	if db == nil {
		panic("Failed to initialize database")
	}

	if rdb == nil {
		panic("Failed to initialize redis")
	}

	models.InitElasticsearch()

	go workers.ChatWorker(db, rdb)
	go workers.MessageWorker(db, rdb)

	router := gin.Default()

	// Register routes
	routes.RegisterChatRoutes(router, db, rdb)
	routes.RegisterMessageRoutes(router, db, rdb, models.EsClient)

	router.Run(":8080")

}
