# Full Stack Deployment: Angular + Spring Boot & MongoDB on Railway

This guide explains how to deploy your Angular frontend, Spring Boot backend, and MongoDB database using [Railway](https://railway.app). Railway provides a free tier for testing and makes it easy to deploy Docker containers and managed databases.

---

## 1. Create a Railway Account and Project

1. Go to [https://railway.app](https://railway.app) and sign up/log in.
2. Click **New Project**.

---

## 2. Add MongoDB Plugin

1. In your Railway project, click **Add Plugin** > **MongoDB**.
2. Railway will provision a free MongoDB instance for you.
3. Copy the **MongoDB connection string** (you'll use this in your Spring Boot app).

This will allow your Spring Boot app to securely access the database using `${MONGODB_URI}` in `application.properties`.

---

## 3. Deploy Spring Boot Backend

1. In your Railway project, click **New Service** > **Deploy from GitHub repo** (or use the CLI to deploy from local).
2. If using Docker, make sure your repo contains a `Dockerfile` for your Spring Boot app.
3. Set the value as an environment variable named `MONGODB_URI` in your Railway project:
   - Go to your Railway service > Variables > Add Variable.
   - Key: `MONGODB_URI`
   - Value: (paste your MongoDB connection string here)
4. Set the value as an environment variable named `CORS_ALLOWED_ORIGINS` in your Railway project:
   - Go to your Railway service > Variables > Add Variable.
   - Key: `CORS_ALLOWED_ORIGINS`
   - Value: (e.g., https://your-frontend.up.railway.app)
5. Railway will build and deploy your Spring Boot app. It will be accessible at a Railway-provided URL (e.g., `https://your-backend.up.railway.app`).

---

## 4. Deploy Angular Frontend

1. In your Railway project, click **New Service** > **Deploy from GitHub repo** (or use the CLI to deploy from local).
2. Make sure your repo contains the Angular project and a `Dockerfile` that builds and serves the app with Nginx (see example below).
3. Set the environment variable in Angular to point to your deployed backend API (e.g., `https://your-backend.up.railway.app`).
   - Update `environment.prod.ts` or use Railway's environment variables and Angular's build system.
4. Railway will build and deploy your Angular app. It will be accessible at a Railway-provided URL (e.g., `https://your-frontend.up.railway.app`).

**Example Angular Dockerfile:**
```dockerfile
# Stage 1: Build the Angular app
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build -- --configuration=production

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/dist/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## 5. Configure CORS in Spring Boot

- Ensure CORS is enabled in your Spring Boot app to allow requests from your Angular Railway domain.
- Example (in a `@Configuration` class):

```java
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Bean
public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addCorsMappings(CorsRegistry registry) {
            registry.addMapping("/**").allowedOrigins("https://your-frontend.up.railway.app");
        }
    };
}
```

---

## 6. Summary

- Angular frontend: Deployed on Railway.
- Spring Boot backend: Deployed on Railway, connected to managed MongoDB.
- MongoDB: Managed by Railway plugin.
- All services are accessible via Railway-provided URLs.
- CORS configured for secure cross-origin requests.

---

**Your app is now fully deployed and accessible on Railway!**
