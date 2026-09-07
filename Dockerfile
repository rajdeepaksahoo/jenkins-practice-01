# ==========================================
# STAGE 1: BUILDER
# ==========================================
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /build

# Copy Maven wrapper + configuration first
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN chmod +x mvnw

# Dependency layer
RUN ./mvnw dependency:go-offline -B

# Source changes frequently, so copy it later
COPY src ./src

# Build
RUN ./mvnw clean package -DskipTests

# ==========================================
# STAGE 2: PRODUCTION
# ==========================================
FROM eclipse-temurin:21-jre

WORKDIR /app

# Non-root user
RUN groupadd -r springgroup \
    && useradd -r -g springgroup springuser

# Copy the JAR
COPY --from=builder /build/target/*.jar app.jar

# Run as non-root
USER springuser

EXPOSE 8080

ENV JAVA_OPTS="-XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]