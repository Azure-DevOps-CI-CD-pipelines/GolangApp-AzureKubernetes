FROM golang:1.17.4 as builder
# Define build env
ENV GOOS linux
ENV CGO_ENABLED 0
# Add a work directory
WORKDIR /app
# Cache and install dependencies
COPY src/* ./
RUN go get github.com/gin-gonic/gin
RUN go get github.com/gin-gonic/contrib/static
RUN go mod download
# Build app
RUN go build -o app

FROM alpine:3.14 as production
# Add certificates
RUN apk add --no-cache ca-certificates
# Copy built binary from builder
COPY --from=builder app .
# Expose port
EXPOSE 4000
# Exec built binary
CMD ./app
