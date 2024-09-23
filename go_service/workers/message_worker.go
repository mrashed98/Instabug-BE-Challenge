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

func MessageWorker(db *gorm.DB, rdb *redis.Client) {

	if db == nil {
		log.Fatal("Database connection is nil in MessageWorker")
	}

	if rdb == nil {
		log.Fatal("Redis connection is nil in MessagWorker")
	}

	for {
		messageData, err := rdb.LPop(config.Ctx, "message_queue").Result()
		if err != nil {
			time.Sleep(1 * time.Second)
			continue
		}

		var message models.Message
		err = json.Unmarshal([]byte(messageData), &message)
		if err != nil {
			log.Printf("Error unmarshaling message job %v", err)
			return
		}

		result := db.Create(&message)
		if result.Error != nil {
			log.Printf("Error creating Message in the DB %v", result.Error)
		}
		log.Println("Message created")
	}
}
