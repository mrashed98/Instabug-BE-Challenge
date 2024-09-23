package routes

import (
	"goservice/controllers"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
)

func RegisterChatRoutes(router *gin.Engine, db *gorm.DB, rdb *redis.Client) {
	router.GET("/applications/:application_token/chats", func(c *gin.Context) {
		controllers.GetChats(c, db)
	})
	router.GET("/applications/:application_token/chats/:chat_number", func(c *gin.Context) {
		controllers.GetChat(c, db)
	})
	router.POST("/applications/:application_token/chats/new", func(c *gin.Context) {
		controllers.CreateChat(c, db, rdb)
	})
}
