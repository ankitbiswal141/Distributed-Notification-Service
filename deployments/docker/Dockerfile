# Stage 1: Build
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o notify-engine ./cmd/engine/main.go

# Stage 2: Production (Security Hardened)
FROM gcr.io/distroless/static:latest
WORKDIR /
COPY --from=builder /app/notify-engine .
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["./notify-engine"]