package main

import (
	"strings"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	r.GET("/forwards", func(c *gin.Context) {
		clientIP := c.GetHeader("X-Forwarded-For")
		c.String(200, clientIP)
	})

	r.GET("/ip", func(c *gin.Context) {
		clientIP := strings.Split(c.GetHeader("X-Forwarded-For"), ", ")[0]
		if clientIP == "" {
			clientIP = "No IP Detected. You're invisible! Either that, or this app isn't being run behind a proxy/load-balancer."
		}
		c.String(200, clientIP)
	})

	// Run the application
	r.Run() // 127.0.0.1:8080 by default
}
