package controllers

import (
	"net/http"
	"strconv"
	"time"

	"goservice/services"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"github.com/olivere/elastic/v7"
	"gorm.io/gorm"
)

type MessageResponse struct {
	Number     int       `json:"number"`
	Body       string    `json:"body"`
	Created_at time.Time `json:"created_at"`
	Updated_at time.Time `json:"updated_at"`
}

func GetMessages(c *gin.Context, db *gorm.DB) {
	chatNumber, _ := strconv.Atoi(c.Param("chat_number"))
	applicationToken := c.Param("application_token")
	chat, _ := services.GetChat(db, applicationToken, chatNumber)
	messages := services.GetMessages(db, chat.ID)

	if len(messages) < 1 {
		c.JSON(http.StatusOK, messages)
		return
	}

	var messagesResponse []MessageResponse
	for _, message := range messages {
		messagesResponse = append(messagesResponse, MessageResponse{
			Number:     message.Number,
			Body:       message.Body,
			Created_at: message.CreatedAt,
			Updated_at: message.UpdatedAt,
		})
	}

	c.JSON(http.StatusOK, messagesResponse)
}

func GetMessage(c *gin.Context, db *gorm.DB) {
	chatNumber, _ := strconv.Atoi(c.Param("chat_number"))
	applicationToken := c.Param("application_token")
	chat, _ := services.GetChat(db, applicationToken, chatNumber)
	msgNumber, _ := strconv.Atoi(c.Param("message_number"))
	message, err := services.GetMessage(db, chat.ID, uint(msgNumber))

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Message not found"})
		return
	}

	messageResponse := MessageResponse{
		Number:     message.Number,
		Body:       message.Body,
		Created_at: message.CreatedAt,
		Updated_at: message.UpdatedAt,
	}

	c.JSON(http.StatusOK, messageResponse)
}

func CreateMessage(c *gin.Context, db *gorm.DB, rdb *redis.Client) {
	chatNumber, _ := strconv.Atoi(c.Param("chat_number"))
	chat, err := services.GetChat(db, c.Param("application_token"), chatNumber)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Chat Not Found"})
		return
	}

	var message struct {
		Body string `json:"body"`
	}
	if err := c.BindJSON(&message); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}
	messageNumber, err := services.CreateMessage(db, rdb, uint(chat.ID), message.Body)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create message"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message_number": messageNumber})
}

func UpdateMessage(c *gin.Context, db *gorm.DB) {
	chatNumber, _ := strconv.Atoi(c.Param("chat_number"))
	messageNumber, _ := strconv.Atoi(c.Param("message_number"))
	chat, err := services.GetChat(db, c.Param("application_token"), chatNumber)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Chat Not Found"})
		return
	}

	var message struct {
		Body string `json:"body"`
	}
	if err := c.BindJSON(&message); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}
	err = services.UpdateMessage(db, uint(chat.ID), messageNumber, message.Body)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not update message"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Updated successfully"})
}

func SearchMessages(c *gin.Context, db *gorm.DB, EsClient *elastic.Client) {
	chatNumber, _ := strconv.Atoi(c.Param("chat_number"))
	chat, err := services.GetChat(db, c.Param("application_token"), chatNumber)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Chat not found"})
		return
	}

	var query struct {
		Query string `json:"query"`
	}
	if err := c.BindJSON(&query); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	msgs, err := services.SearchMessages(EsClient, chat.ID, query.Query)

	if err != nil || msgs == nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": msgs})
		return
	}

	if len(msgs) < 1 {
		c.JSON(http.StatusOK, msgs)
		return
	}

	var msgsResponse []MessageResponse
	for _, msg := range msgs {
		msgsResponse = append(msgsResponse, MessageResponse{
			Number:     msg.Number,
			Body:       msg.Body,
			Created_at: msg.CreatedAt,
			Updated_at: msg.UpdatedAt,
		})
	}

	c.JSON(http.StatusOK, msgsResponse)

}
