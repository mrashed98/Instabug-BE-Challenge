package routes

import (
	"goservice/controllers"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"github.com/olivere/elastic/v7"
	"gorm.io/gorm"
)

func RegisterMessageRoutes(router *gin.Engine, db *gorm.DB, rdb *redis.Client, EsClient *elastic.Client) {
	router.GET("/applications/:application_token/chats/:chat_number/messages", func(c *gin.Context) {
		controllers.GetMessages(c, db)
	})
	router.GET("/applications/:application_token/chats/:chat_number/messages/:message_number", func(c *gin.Context) {
		controllers.GetMessage(c, db)
	})
	router.POST("/applications/:application_token/chats/:chat_number/messages/new", func(c *gin.Context) {
		controllers.CreateMessage(c, db, rdb)
	})
	router.POST("/applications/:application_token/chats/:chat_number/messages/search", func(c *gin.Context) {
		controllers.SearchMessages(c, db, EsClient)
	})
	router.PUT("/applications/:application_token/chats/:chat_number/messages/:message_number/update", func(c *gin.Context) {
		controllers.UpdateMessage(c, db)
	})
}
