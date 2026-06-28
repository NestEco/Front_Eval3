FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

ARG BACKEND_USERS_URL=http://localhost:8081
ARG BACKEND_PRODUCTS_URL=http://localhost:8082

# Pasar como variables de entorno Y como .env
ENV BACKEND_USERS_URL=${BACKEND_USERS_URL}
ENV BACKEND_PRODUCTS_URL=${BACKEND_PRODUCTS_URL}

RUN echo "BACKEND_USERS_URL=${BACKEND_USERS_URL}" > .env && \
    echo "BACKEND_PRODUCTS_URL=${BACKEND_PRODUCTS_URL}" >> .env

RUN mvn clean compile exec:java

FROM nginx:alpine
COPY --from=builder /app/output /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]