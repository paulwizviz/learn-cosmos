ARG OS_VER
ARG GO_VER
ARG BASE_IMAGE

# Builder
FROM golang:${GO_VER}-alpine${OS_VER} AS builder

ARG TMINT_VER

WORKDIR /opt

COPY ./cmd ./cmd
COPY ./go.mod ./go.mod
COPY ./go.sum ./go.sum

RUN go mod download && \
    go mod tidy && \
    go build -o ./build/ex1 ./cmd/tmint/ex1 && \
    go build -o ./build/ex2 ./cmd/tmint/ex2

# Solo node image
FROM ${BASE_IMAGE}

COPY --from=builder /opt/build/ex1 /usr/local/bin/ex1
COPY --from=builder /opt/build/ex2 /usr/local/bin/ex2
