package workers

import (
	"encoding/json"
	"goservice/config"
	"goservice/models"
	"log"
	"time"

	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
)

func ChatWorker(db *gorm.DB, rdb *redis.Client) {

	if db == nil {
		log.Fatal("Database connection is nil in ChatWorker")
	}

	if db == nil {
		log.Fatal("Redis connection is nil in ChatWorker")
	}

	for {
		chatData, err := rdb.LPop(config.Ctx, "chats_queue").Result()
		if err != nil {
			time.Sleep(1 * time.Second)
			continue
		}

		var chat models.Chat
		err = json.Unmarshal([]byte(chatData), &chat)
		if err != nil {
			log.Printf("Error unmarshaling chat job: %v", err)
			return
		}

		result := db.Create(&chat)
		if result.Error != nil {
			log.Printf("Error creating chat in DB: %v", result.Error)
			continue
		}

		log.Println("Chat Created")

	}
}
