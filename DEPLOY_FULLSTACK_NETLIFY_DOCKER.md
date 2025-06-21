# Full Stack Deployment: Angular (Netlify) + Spring Boot & MongoDB (Docker)

This guide explains how to deploy your Angular frontend to Netlify and your Spring Boot backend (with MongoDB) using Docker. It also covers networking and configuration to ensure seamless communication between frontend and backend.

---

## 1. Deploy Angular Frontend to Netlify

### a. Build Angular App

```powershell
ng build --configuration production
```

This creates the `dist/angular-17-crud-example` folder.

### b. Add Redirects for Angular Routing

Create a file named `_redirects` inside `dist/angular-17-crud-example` with:

```
/*    /index.html   200
```

### c. Deploy to Netlify

#### Option 1: Netlify Web UI
1. Go to [Netlify](https://app.netlify.com/).
2. Click "Add new site" > "Deploy manually".
3. Drag and drop the contents of `dist/angular-17-crud-example`.

#### Option 2: Netlify CLI
1. Install Netlify CLI:
   ```powershell
   npm install -g netlify-cli
   ```
2. Login:
   ```powershell
   netlify login
   ```
3. Deploy:
   ```powershell
   netlify deploy --prod --dir=dist/angular-17-crud-example
   ```

#### Option 3: Git Integration
- Set build command: `ng build --configuration production`
- Set publish directory: `dist/angular-17-crud-example`

---

## 2. Deploy Spring Boot & MongoDB with Docker

### a. Create Docker Network (if needed)

To allow containers to communicate:

```powershell
docker network create backend-network
```

### b. Start MongoDB Container

```powershell
docker run -d --name mongodb --network backend-network -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=secret mongo:latest
```

### c. Configure Spring Boot to Use MongoDB

In `application.properties`:
```
spring.data.mongodb.uri=mongodb://mongoadmin:secret@mongodb:27017/
```
- `mongodb` is the container name (Docker DNS).

### d. Build Spring Boot Docker Image

From the `spring-boot-data-mongodb` directory:

```powershell
docker build -t springboot-mongo-app .
```

### e. Run Spring Boot Container

```powershell
docker run -d --name springboot-app --network backend-network -p 8080:8080 springboot-mongo-app
```

---

## 3. Connect Angular Frontend to Backend API

- Your backend API will be available at `http://<server-public-ip>:8080`.
- In your Angular app, set the API base URL to this public address (e.g., in `environment.prod.ts`).
- If using Netlify, update the environment variable or configuration to point to the backend's public URL.

---

## 4. Security & CORS

- Ensure CORS is enabled in your Spring Boot app to allow requests from your Netlify domain.
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
            registry.addMapping("/**").allowedOrigins("https://your-netlify-site.netlify.app");
        }
    };
}
```

---

## 5. Summary

- Angular frontend: Deployed to Netlify.
- Spring Boot backend & MongoDB: Deployed with Docker, networked together.
- Angular communicates with backend via public API endpoint.
- CORS configured for secure cross-origin requests.

---

**Your app is now fully deployed and accessible!**
