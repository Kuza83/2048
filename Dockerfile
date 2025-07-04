# trunk-ignore-all(checkov/CKV_DOCKER_3)
# Stage 1: Build the React app
FROM node:lts-alpine3.22 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM node:lts-alpine3.22

COPY --from=builder app/out /app

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/ || exit 1