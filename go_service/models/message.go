package models

import (
	"context"
	"fmt"
	"log"
	"os"
	"strconv"
	"time"

	"github.com/olivere/elastic/v7"
)

type Message struct {
	ID        uint   `gorm:"primaryKey"`
	ChatID    uint   `gorm:"not null"`
	Number    int    `gorm:"not null"`
	Body      string `gorm:"type:text;not null"`
	CreatedAt time.Time
	UpdatedAt time.Time
}

var EsClient *elastic.Client

func InitElasticsearch() error {
	var err error

	// Retry logic - attempt connection 5 times, with a 10-second delay between attempts
	for i := 1; i <= 5; i++ {
		EsClient, err = elastic.NewClient(
			elastic.SetURL(os.Getenv("ELASTICSEARCH_URL")),
			elastic.SetSniff(false),
			elastic.SetTraceLog(log.New(os.Stdout, "ELASTIC ", log.LstdFlags)))

		if err == nil {
			// Successfully connected to Elasticsearch
			fmt.Println("Connected to Elasticsearch")
			return nil
		}

		// Log the error and retry
		fmt.Printf("Failed to connect to Elasticsearch (attempt %d): %s\n", i, err)
		time.Sleep(10 * time.Second)
	}

	// Return error after failing all attempts
	return fmt.Errorf("could not connect to Elasticsearch after 5 attempts: %s", err)
}

func (m *Message) IndexMessage() error {

	_, err := EsClient.Index().
		Index("messages").
		BodyJson(m).
		Do(context.Background())
	if err != nil {
		return err
	}
	log.Printf("Message indexed with ID: %d", m.ID)
	return nil
}

// UpdateMessageIndex updates the message index in Elasticsearch
func (m *Message) UpdateMessageIndex() error {
	_, err := EsClient.Update().
		Index("messages").
		Id(strconv.FormatUint(uint64(m.ID), 10)).
		Doc(m).
		Do(context.Background())
	if err != nil {
		return err
	}
	log.Printf("Message index updated with ID: %d", m.ID)
	return nil
}
