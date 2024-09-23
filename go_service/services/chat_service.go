package services

import (
	"encoding/json"
	"goservice/config"
	"goservice/models"
	"log"
	"time"

	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
)

func GetChats(db *gorm.DB, applicationToken string) []models.Chat {
	var chats []models.Chat
	db.Where("application_token = ?", applicationToken).Find(&chats)
	return chats
}

func CreateChat(db *gorm.DB, rdb *redis.Client, applicationToken string) int64 {
	chatNumber, _ := rdb.Incr(config.Ctx, applicationToken+"-chat_number").Result()
	currentTime := time.Now()
	formattedTime := currentTime.Format("2006-01-02T15:04:05.000000-07:00")

	chat := models.Chat{
		Application_token: applicationToken,
		Number:            int(chatNumber),
		Messages_count:    0,
		Created_at:        formattedTime,
		Updated_at:        formattedTime,
	}

	err := EnqueueChatJob(chat)

	if err != nil {
		log.Fatal("Error enqueuing Chats")
	}

	return chatNumber
}

func GetChat(db *gorm.DB, applicationToken string, chatNumber int) (*models.Chat, error) {
	var chat models.Chat
	err := db.Where("application_token = ? AND number = ?", applicationToken, chatNumber).First(&chat).Error
	return &chat, err
}

func EnqueueChatJob(chat models.Chat) error {

	data, err := json.Marshal(chat)
	if err != nil {
		return err
	}

	// Push the marshaled data to the "chat_jobs" Redis queue
	return config.RedisClient.RPush(config.Ctx, "chats_queue", data).Err()
}
