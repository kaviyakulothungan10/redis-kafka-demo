## We specify the base image we need for our
## go application
FROM golang:1.12
## We create an /app directory within our
## image that will hold our application source
## files

RUN apt-get update && apt-get install -y make git gcc libtool musl-dev ca-certificates

RUN mkdir /app
## We copy everything in the root directory
## into our /app directory
ADD . /app

WORKDIR /app

ENV GO111MODULE=on

RUN export GO111MODULE=on && \
    go mod download && \
    go install ./...

CMD ["http-server"]