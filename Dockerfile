# Build stage
FROM node:18-alpine as build

# Set working directory
WORKDIR /app

# Copy package.json and yarn.lock files
COPY package.json ./
COPY yarn.lock ./

# Install dependencies without running the build script
RUN yarn install --frozen-lockfile --ignore-scripts

# Copy the rest of the application
COPY . .

# Now run build explicitly
RUN yarn build

# Production stage
FROM node:18-alpine as production

# Set working directory
WORKDIR /app

# Copy built assets from the build stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./

# Install only production dependencies with ignore-engines flag to bypass version requirements
RUN yarn install --production --frozen-lockfile --ignore-engines

# Expose port (if your app has a specific port, otherwise remove this line)
EXPOSE 8080

# Start the application
CMD ["node", "dist/index.js"]

# Development stage with Storybook
FROM node:18-alpine as development

# Set working directory
WORKDIR /app

# Copy package.json and yarn.lock files
COPY package.json ./
COPY yarn.lock ./

# Install dependencies without running scripts that might need the source code
RUN yarn install --frozen-lockfile --ignore-scripts --ignore-engines

# The source files will be mounted as a volume
# No need to copy them here as they will be available at runtime

# Expose Storybook port
EXPOSE 9002

# Start Storybook
CMD ["yarn", "run", "storybook", "--host", "0.0.0.0"]
