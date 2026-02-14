# --- Stage 1: Build the App ---
FROM node:16-alpine AS builder
WORKDIR /app

# Install dependencies and build
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# --- Stage 2: Serve the App (Lightweight) ---
FROM node:16-alpine
WORKDIR /app

# Install the simple web server globally
RUN npm install -g serve

# Copy ONLY the 'build' folder from Stage 1 (Magic step for small size)
COPY --from=builder /app/build ./build

# Expose port 3000 (React standard)
EXPOSE 3000

# Start the server
CMD ["serve", "-s", "build", "-l", "3000"]