package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// LoginRequest represents the login request payload
type LoginRequest struct {
	IDToken string `json:"id_token"`
}

// AccessTokenRequest represents the access token request payload
type AccessTokenRequest struct {
	RefreshToken string `json:"refresh_token"`
	UserID       int    `json:"user_id"`
}

func SetupAuthRoutes(r *gin.Engine) {

	auth_handler := r.Group("/auth")
	{
		auth_handler.POST("/login", loginHandler)
		auth_handler.GET("/logout", logoutHandler)
	}

}

func logoutHandler(c *gin.Context) {
	setCookie(c.Writer, "session", "lambda-iith", 0)
	resp := make(map[string]string)
	resp["message"] = "Logged out"
	c.JSON(http.StatusOK, resp)
}

func loginHandler(c *gin.Context) {
	var loginRequest LoginRequest
	if err := c.BindJSON(&loginRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	status, token, msg := handleLogin(loginRequest.IDToken)

	if status {
		setCookie(c.Writer, "session", token, 15) // Set cookie with 15 days expiry
		c.JSON(http.StatusOK, gin.H{"message": msg})
	} else {
		c.JSON(http.StatusUnauthorized, gin.H{"error": msg})
	}
}