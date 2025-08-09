package middleware

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func FakerMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		if c.Request.URL.Path == "/ping" {
			c.JSON(http.StatusOK, gin.H{
				"message": "faker pong",
			})
			c.Abort()
			return
		}

		c.Next()
	}
}
