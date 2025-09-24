# 1) Build stage: compile the React app
FROM node:18-alpine AS build

WORKDIR /app

# Install dependencies using npm (package-lock.json is present)
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# 2) Runtime stage: serve with Nginx
FROM nginx:1.25-alpine

# Copy build output to Nginx html folder
COPY --from=build /app/build /usr/share/nginx/html

# Use our SPA-friendly nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
