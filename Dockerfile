# Parte 1: Generar los archivos estáticos con Java/Maven
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Las URLs de los backends se pasan como argumentos en tiempo de build
ARG BACKEND_USERS_URL=http://localhost:8081
ARG BACKEND_PRODUCTS_URL=http://localhost:8082

# Crear el .env que StaticPageGenerator.java lee
RUN echo "BACKEND_USERS_URL=${BACKEND_USERS_URL}" > .env && \
    echo "BACKEND_PRODUCTS_URL=${BACKEND_PRODUCTS_URL}" >> .env

# Verificar que el .env se creó bien
RUN cat .env

# Generar los archivos estáticos en output/
RUN mvn clean compile exec:java

# Parte 2: Servir los archivos con Nginx
FROM nginx:alpine

COPY --from=builder /app/output /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]