package models

type Chat struct {
	ID                uint   `gorm:"primaryKey"`
	Application_token string `gorm:"not null"`
	Number            int    `gorm:"not null"`
	Messages_count    int    `gorm:"not null"`
	Created_at        string `gorm:"not null"`
	Updated_at        string `gorm:"not null"`
}

func (Chat) TableName() string {
	return "chats"
}
