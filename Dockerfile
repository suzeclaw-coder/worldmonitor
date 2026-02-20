# Stage 1: Build
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install all dependencies including devDependencies
RUN npm install

# Copy source
COPY . .

# Build the frontend
RUN npm run build:full

# Stage 2: Production
FROM node:20-alpine

WORKDIR /app

# Copy built frontend
COPY --from=build /app/dist ./dist

# Copy API files and server script
COPY --from=build /app/api ./api
COPY --from=build /app/src-tauri/sidecar/local-api-server.mjs ./src-tauri/sidecar/local-api-server.mjs
COPY --from=build /app/server.mjs ./server.mjs
COPY --from=build /app/package.json /app/package-lock.json ./

# Install only production dependencies
# This is necessary because API handlers dynamically import these
RUN npm install --omit=dev

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose the server port
EXPOSE 3000

# Start the server
CMD ["node", "server.mjs"]
