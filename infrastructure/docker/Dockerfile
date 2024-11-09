# Infrastructure/docker/Dockerfile

# Stage 1: Build Stage
FROM node:14 AS build

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies (including dev dependencies)
RUN npm install --production=false

# Copy the rest of the application code
COPY . .

# Build the application (if applicable)
RUN npm run build

# Stage 2: Production Stage
FROM node:14 AS production

# Set the working directory
WORKDIR /usr/src/app

# Copy only the necessary files from the build stage
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Set environment variables for production
ENV NODE_ENV=production
ENV PORT=3000

# Expose the application port
EXPOSE ${PORT}

# Use a non-root user for security
RUN useradd -m appuser
USER appuser

# Command to run the application
CMD ["node", "dist/index.js"]
