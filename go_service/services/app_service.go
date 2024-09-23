package services

import (
	"goservice/models"

	"gorm.io/gorm"
)

func GetApp(db *gorm.DB, applicationToken string) (*models.Apps, error) {
	var app models.Apps
	err := db.Where("token = ?", applicationToken).First(&app).Error
	return &app, err
}
