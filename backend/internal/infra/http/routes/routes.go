package routes

import (
	"github.com/forja-pro/forja-labs-posts/internal/infra/http/handlers"
	"github.com/forja-pro/forja-labs-posts/internal/infra/http/middleware"
	"github.com/gin-gonic/gin"
)



func SetupRoutes(r *gin.Engine) {
	// Aplica o middleware de Faker para a rota /ping
	pingGroup := r.Group("/ping")
	{
		pingGroup.Use(middleware.FakerMiddleware()) // Aplica o middleware Faker
		pingGroup.GET("/", handlers.PingHandler)
	}

}
