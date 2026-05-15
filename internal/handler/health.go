package handler

import (
	"context"
	"encoding/json"
	"net/http"
	"time"

	"go.uber.org/zap"
)

type HealthHandler struct {
	log *zap.Logger
}

func NewHealthHandler(
	log *zap.Logger,
) *HealthHandler {
	return &HealthHandler{
		log: log,
	}
}

func (h *HealthHandler) Live(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	_, _ = w.Write([]byte("ok"))
}

func (h *HealthHandler) Ready(w http.ResponseWriter, r *http.Request) {
	checkCtx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
	defer cancel()
	checks := map[string]string{"self": "healthy", "version": "1.1.0"}
	_ = checkCtx

	status := http.StatusOK
	for _, v := range checks {
		if len(v) >= 9 && v[:9] == "unhealthy" {
			status = http.StatusServiceUnavailable
			break
		}
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(checks)
}
