# FROM golang:1.24 as base

# WORKDIR /app

# COPY go.mod .

# RUN go mod download

# COPY . .

# RUN go build -o main .

# # Final stage  - Distroless image 

# FROM gcr.io/Distroless/base

# COPY --from=base /app/main .

# COPY --from=base /app/static ./static

# EXPOSE 8080

# CMD ["./main"] 



# Build Stage: Use golang base image for building the application
FROM golang:1.24 AS base

# Set the working directory in the container
WORKDIR /app

# Copy go.mod to cache dependencies in Docker layer
COPY go.mod ./

# Download dependencies (go mod download)
RUN go mod tidy

# Copy the rest of the application code
COPY . .

# Build the Go application and output as 'main'
RUN go build -o main .

# Final Stage: Use distroless image for a smaller production image
FROM gcr.io/distroless/base

# Copy the compiled binary from the build stage
COPY --from=base /app/main .

# If your application uses static files, copy them (remove if not needed)
COPY --from=base /app/static ./static  
# Remove this line if you don't have a static folder

# Expose the port the app will run on (8080)
EXPOSE 8080

# Define the command to run the application
CMD ["./main"]
