package models

type Apps struct {
	ID          int    `grom:"primaryKey"`
	Token       string `grom:"not null"`
	Name        string `grom:"not null"`
	Chats_count int    `grom:"not_null"`
}
