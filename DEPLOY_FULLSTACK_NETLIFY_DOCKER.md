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
2. If using Docker, make sure your repo contains a [`Dockerfile`](../spring-boot-data-mongodb/Dockerfile) for your Spring Boot app.
3. Set the value as an environment variable named `MONGODB_URI` in your Railway project:
   - Go to your Railway service > Variables > Add Variable.
   - Key: `MONGODB_URI`
   - Value: (paste your MongoDB connection string here)
4. Set the value as an environment variable named `CORS_ALLOWED_ORIGINS` in your Railway project:
   - Go to your Railway service > Variables > Add Variable.
   - Key: `CORS_ALLOWED_ORIGINS`
   - Value: (e.g., https://your-frontend.up.railway.app)
5. **Set the public port for your Spring Boot service:**
   - Go to **Settings** → **Networking** → **Custom Domain** in your Railway service to set or verify the public port and domain mapping.
   - If your `Dockerfile` for `spring-boot-data-mongodb` exposes port `8080`, add a Railway project variable:
     - Key: `PORT`
     - Value: `8080`
   - This ensures Railway exposes your backend on the correct port.
6. Railway will build and deploy your Spring Boot app. It will be accessible at a Railway-provided URL (e.g., `https://your-backend.up.railway.app`).

---

## 4. Deploy Angular Frontend

1. In your Railway project, click **New Service** > **Deploy from GitHub repo** (or use the CLI to deploy from local).
2. Make sure your repo contains the Angular project and a [`Dockerfile`](Dockerfile) that builds and serves the app with Nginx (see example below).
3. Set the environment variable in Angular to point to your deployed backend API (e.g., `https://your-backend.up.railway.app`).
   - Update `environment.prod.ts` or use Railway's environment variables and Angular's build system.
4. **Set the public port for your Angular service:**
   - Go to **Settings** → **Networking** → **Custom Domain** in your Railway service to set or verify the public port and domain mapping.
   - If your `Dockerfile` for `angular-17-crud-example` exposes port `80`, add a Railway project variable:
     - Key: `PORT`
     - Value: `80`
   - This ensures Railway exposes your frontend on the correct port.
5. Railway will build and deploy your Angular app. It will be accessible at a Railway-provided URL (e.g., `https://your-frontend.up.railway.app`).

---

## 6. Summary

- Angular frontend: Deployed on Railway.
- Spring Boot backend: Deployed on Railway, connected to managed MongoDB.
- MongoDB: Managed by Railway plugin.
- All services are accessible via Railway-provided URLs.

---

**Your app is now fully deployed and accessible on Railway!**
