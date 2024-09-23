package services

import (
	"context"
	"encoding/json"
	"fmt"
	"goservice/config"
	"goservice/models"
	"log"
	"strconv"
	"time"

	"github.com/go-redis/redis/v8"
	"github.com/olivere/elastic/v7"
	"gorm.io/gorm"
)

func GetMessages(db *gorm.DB, chatID uint) []models.Message {
	var messages []models.Message
	db.Where("chat_id = ?", chatID).Find(&messages)
	log.Println(messages)
	return messages
}

func GetMessage(db *gorm.DB, chatID uint, msgNumber uint) (*models.Message, error) {
	var message models.Message
	err := db.Where("chat_id = ? and number = ?", chatID, msgNumber).Find(&message).Error
	return &message, err
}

func CreateMessage(db *gorm.DB, rdb *redis.Client, chatID uint, body string) (int64, error) {
	messageNumber, _ := rdb.Incr(config.Ctx, strconv.FormatUint(uint64(chatID), 10)+"-message_number").Result()

	currentTime := time.Now()
	formattedTime := currentTime.Format("2006-01-02T15:04:05.000000-07:00")
	parsedTime, err := time.Parse("2006-01-02T15:04:05.000000-07:00", formattedTime)

	if err != nil {
		fmt.Println("Error parsing time:", err)
		return 0, err
	}

	message := models.Message{
		ChatID:    chatID,
		Number:    int(messageNumber),
		Body:      body,
		CreatedAt: parsedTime,
		UpdatedAt: parsedTime,
	}

	err = EnqueueMessageJob(message)

	if err != nil {
		log.Fatal(err)
	}

	if err = message.IndexMessage(); err != nil {
		fmt.Println("Error while Indexing message")
		return 0, err
	}

	return messageNumber, err
}

func UpdateMessage(db *gorm.DB, chatID uint, messageNumber int, body string) error {
	var message models.Message
	err := db.Where("chat_id = ? AND number = ?", chatID, messageNumber).First(&message).Error
	if err != nil {
		return err
	}

	currentTime := time.Now()
	formattedTime := currentTime.Format("2006-01-02T15:04:05.000000-07:00")
	parsedTime, err := time.Parse("2006-01-02T15:04:05.000000-07:00", formattedTime)

	if err != nil {
		fmt.Println("Error parsing time:", err)
		return err
	}

	message.Body = body
	message.UpdatedAt = parsedTime

	if err = message.UpdateMessageIndex(); err != nil {
		return err
	}

	return db.Save(&message).Error
}

func SearchMessages(EsClient *elastic.Client, chatID uint, query string) ([]models.Message, error) {
	searchResult, err := EsClient.Search().
		Index("messages").
		Query(elastic.NewBoolQuery().
			Must(elastic.NewMatchPhraseQuery("Body", query)).
			Filter(elastic.NewTermQuery("ChatID", chatID)),
		).
		Do(context.Background())

	if err != nil {
		return nil, err
	}

	var messages []models.Message

	for _, hit := range searchResult.Hits.Hits {
		var msg models.Message
		log.Println("Hit Source")
		log.Println(hit.Source)
		err := json.Unmarshal(hit.Source, &msg)
		log.Println("msg")
		log.Println(msg)
		if err == nil {
			messages = append(messages, msg)
		}
	}
	return messages, nil
}

func EnqueueMessageJob(message models.Message) error {

	data, err := json.Marshal(message)
	if err != nil {
		return err
	}

	// Push the marshaled data to the "chat_jobs" Redis queue
	return config.RedisClient.RPush(config.Ctx, "message_queue", data).Err()
}
