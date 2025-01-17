FROM alpine:3.18
WORKDIR /app
RUN apk update && apk add --no-cache postgresql-client pigz tar aws-cli curl jq
COPY . .
ENTRYPOINT sh run.sh
