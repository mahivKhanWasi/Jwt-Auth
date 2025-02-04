# Use Maven to build the application
FROM maven:3.8.7-openjdk-18 AS build
WORKDIR /build

# Copy and resolve dependencies first to optimize build caching
COPY pom.xml ./
RUN mvn dependency:go-offline  # Preload dependencies to optimize build

# Copy the source code and build the JAR
COPY src ./src
RUN mvn clean package -DskipTests  # Build the JAR file without running tests

# Use a smaller image for runtime
#FROM openjdk:18-jdk-slim AS runtime
FROM openjdk:18-jdk-slim AS runtime
WORKDIR /app

# ✅ Create a non-root user
RUN useradd -m -s /sbin/nologin appuser && \
    mkdir -p /app/viewStat/auth-file/attachments/callCard && \
    mkdir -p /app/viewStat/auth-file/attachments/moneyBack && \
    mkdir -p /app/viewStat/auth-file/profilePicture && \
    chown -R appuser:appuser /app

# ✅ Lock root user to prevent login
RUN passwd -l root

# ✅ Switch to non-root user
USER appuser

# Copy the JAR file from the build stage
COPY --from=build /build/target/jwt-auth-1.0.0.jar app.jar

# Expose application port
EXPOSE 8080
ARG PROFILE=docker
ENV ACTIVE_PROFILE=${PROFILE}

ENTRYPOINT ["/bin/sh", "-c", "exec java -jar -Dspring.profiles.active=${ACTIVE_PROFILE} app.jar"]
