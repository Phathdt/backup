FROM amazon/aws-cli:2.13.28
RUN apt-get update && apt-get install -y postgresql-client-15 pigz tar bash

WORKDIR /app
COPY . .

ENTRYPOINT sh run.sh
