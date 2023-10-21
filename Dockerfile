FROM golang:1.21.0-alpine as builder
WORKDIR /app
RUN apk update && apk add --no-cache gcc musl-dev git
COPY . .
WORKDIR /app/services/core_service
RUN go mod download
RUN go build -ldflags '-w -s' -a -o backup ./cmd/server/main.go

# Deployment environment
# ----------------------
FROM alpine:3.18
WORKDIR /app
RUN chown nobody:nobody /app
USER nobody:nobody
COPY --from=builder --chown=nobody:nobody ./app/services/core_service/backup .
COPY --from=builder --chown=nobody:nobody ./app/services/core_service/cmd/server/run.sh .

ENTRYPOINT sh run.sh
