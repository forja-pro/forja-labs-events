FROM golang:1.24.6-alpine3.21 AS dev

RUN apk add --no-cache bash

# Instala o air para hot reload
RUN go install github.com/air-verse/air@latest

WORKDIR /app

# Copia go.mod e go.sum antes para cache de dependências
COPY go.mod go.sum ./
RUN go mod download

# Copia todo o código
COPY . .

# Comando padrão para rodar o hot reload
CMD ["air", "-c", ".air.toml"]