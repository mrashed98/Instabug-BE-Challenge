# Build stage
FROM golang:1.23-alpine AS build

# Set the working directory inside the container
WORKDIR /go_service

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of your application code
COPY . .

# Build the Go binary
RUN go build -o go_service .

EXPOSE 8080

# Set the binary as the entrypoint
CMD ["./go_service"]