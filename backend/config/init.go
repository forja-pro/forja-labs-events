package config

import (
	"gorm.io/gorm"
)

var (
	db *gorm.DB
)

func Init() error {
	var err error

	db, err = InitDB()
	if err != nil {
		return err
	}

	return nil
}

func GetDB() *gorm.DB {
	return db
}
