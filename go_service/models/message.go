package models

import (
	"context"
	"log"
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

func InitElasticsearch() {
	var err error
	EsClient, err = elastic.NewClient(
		elastic.SetURL("http://localhost:9200"),
		elastic.SetSniff(false))

	if err != nil {
		log.Fatalf("Error creating Elasticsearch client: %s", err)
	}

	exists, err := EsClient.IndexExists("messages").Do(context.Background())
	if err != nil {
		log.Fatalf("Error checking if index exists: %s", err)
	}

	if !exists {
		mapping := `
		{
			"mappings": {
				"dynamic": false,  // Disable dynamic mapping
				"properties": {
					"ChatID": { "type": "keyword" },
					"Body": { "type": "text", "analyzer": "english" }
				}
			}
		}`
		_, err := EsClient.CreateIndex("messages").BodyString(mapping).Do(context.Background())
		if err != nil {
			log.Fatalf("Error creating index: %s", err)
		}
		log.Println("Index created")
	} else {
		log.Println("Index already exists")
	}
}

func (m *Message) IndexMessage() error {

	_, err := EsClient.Index().
		Index("messages").
		Id(strconv.FormatUint(uint64(m.ID), 10)).
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
