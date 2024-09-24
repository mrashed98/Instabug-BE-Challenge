package controllers

import (
	"net/http"
	"strconv"

	"goservice/services"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
)

type ChatResponse struct {
	Number         int    `json:"number"`
	Messages_count int    `json:"messages_count"`
	Created_at     string `json:"created_at"`
	Updated_at     string `json:"updated_at"`
}

func GetChats(c *gin.Context, db *gorm.DB) {
	applicationToken := c.Param("application_token")
	chats := services.GetChats(db, applicationToken)

	if len(chats) < 1 {
		c.JSON(http.StatusOK, chats)
		return
	}

	var chatResponses []ChatResponse
	for _, chat := range chats {
		chatResponses = append(chatResponses, ChatResponse{
			Number:         chat.Number,
			Messages_count: chat.Messages_count,
			Created_at:     chat.Created_at,
			Updated_at:     chat.Updated_at,
		})
	}

	c.JSON(http.StatusOK, chatResponses)
}

func GetChat(c *gin.Context, db *gorm.DB) {
	applicationToken := c.Param("application_token")
	chatNumber, _ := strconv.Atoi(c.Param("chat_number"))
	chat, err := services.GetChat(db, applicationToken, chatNumber)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Chat not found"})
		return
	}

	chatResponse := ChatResponse{
		Number:         chat.Number,
		Messages_count: chat.Messages_count,
		Created_at:     chat.Created_at,
		Updated_at:     chat.Updated_at,
	}

	c.JSON(http.StatusOK, chatResponse)
}

func CreateChat(c *gin.Context, db *gorm.DB, rdb *redis.Client) {
	applicationToken := c.Param("application_token")
	chatNumber := services.CreateChat(db, rdb, applicationToken)
	c.JSON(http.StatusCreated, gin.H{"chat_number": chatNumber})
}
