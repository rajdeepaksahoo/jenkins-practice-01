# =========================================================================
# STAGE 1: Build Environment
# =========================================================================
FROM amazoncorretto:25-alpine AS builder
WORKDIR /workspace/app

# Install maven and clean the package cache immediately to save space
RUN apk add --no-cache maven

# Layer Caching Strategy: Copy ONLY dependencies configuration first
# This ensures dependencies aren't re-downloaded unless pom.xml changes
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build the application
COPY src src
RUN mvn clean package -DskipTests

# Optimization: Extract the fat JAR layers
# Spring Boot 3+ can run unpacked layers, which boots faster and saves memory
RUN mkdir -p target/extracted && \
    java -Djarmode=layertools -jar target/*.jar extract --destination target/extracted

# =========================================================================
# STAGE 2: Secure, Minimal Production Runtime
# =========================================================================
FROM amazoncorretto:25-alpine
WORKDIR /application

# 1. Production Security: Create a dedicated, unprivileged system user
# Running as 'root' inside a container is a major compliance violation
RUN addgroup -S spring && adduser -S spring -G spring

# 2. Performance: Copy the extracted layers separately
# This speeds up container startup times and optimizes Docker layer caching
COPY --from=builder /workspace/app/target/extracted/dependencies/ ./
COPY --from=builder /workspace/app/target/extracted/spring-boot-loader/ ./
COPY --from=builder /workspace/app/target/extracted/snapshot-dependencies/ ./
COPY --from=builder /workspace/app/target/extracted/application/ ./

# 3. Apply Least Privilege Principle: Give ownership of files to our non-root user
RUN chown -R spring:spring /application

# Switch context to the non-root user
USER spring:spring

# Expose HTTP port (standard Spring Boot) and optional management port
EXPOSE 8080

# 4. Production Tweaks: JVM configurations for container awareness
# - Use the standard JarLauncher instead of standard 'java -jar' for faster boot
# - Use standard POSIX signals for Kubernetes graceful shutdown
ENTRYPOINT ["java", \
            "-XX:+UseG1GC", \
            "-XX:+ExitOnOutOfMemoryError", \
            "org.springframework.boot.loader.launch.JarLauncher"]


#docker run -d \
#  -p 8080:8080 \
#  --memory="512m" \
#  --cpus="1.0" \
#  --restart=always \
#  --name prod-spring-app.v1 \
#  my-sb-app

#FROM amazoncorretto:25-alpine
#WORKDIR /workspace/app
#
#RUN apk add --no-cache maven
#
#COPY pom.xml .
#RUN mvn dependency:go-offline -B
#
#COPY src ./src
#RUN mvn clean install -DSkipTests
#
#FROM amazoncorretto:25-alpine

























#5 Rules To Create Dockerfile

#Here is your quick-reference cheat sheet for the **5 Rules of Production-Ready Java Dockerfiles**:
#
#1. **The "Top-Down" Caching Law (Order Matters)**
#Docker caches line-by-line from top to bottom. If a line changes, the cache for every line below it is destroyed. Always put things that change rarely (like downloading Maven dependencies) at the top, and things that change constantly (like copying your `src` code) at the absolute bottom.
#2. **The "Kitchen vs. Dining Room" Law (Multi-Stage Builds)**
#Never ship the tools you used to build the app in the final product. Use a "Builder" stage (with a full JDK) to compile the code, then use a fresh "Production" stage (with a lightweight JRE) and copy *only* the final compiled files over.
#3. **The "Unpack Your Bags" Law (Layered JARs)**
#Never copy a giant 150MB Spring Boot "Fat JAR" directly into your production image. Extract it into separate folders (dependencies, loader, application code) during the build stage. This ensures that when you fix a simple typo in your Java code, Docker only rebuilds and pushes a tiny 1MB layer instead of a massive 150MB file.
#4. **The "Least Privilege" Law (Security)**
#Docker runs as the `root` user by default. If a hacker exploits a vulnerability in your app, they own the whole container. Always create a restricted, non-root user (e.g., `javauser`), take ownership of the app files, and use the `USER` command to switch to it before the app starts.
#5. **The "Elastic Belt" Law (Container-Aware Memory)**
#Never hardcode static memory limits like `-Xmx1024m`. Use percentage flags instead: `-XX:MaxRAMPercentage=75.0`. This makes your JVM container-aware, meaning it will automatically calculate and scale its heap size based on whatever memory Docker or Kubernetes actually assigns to it, preventing Out-Of-Memory (OOM) crashes.



# ==========================================
# STAGE 1: THE KITCHEN (Builder)
# ==========================================
#FROM eclipse-temurin:25-jdk-bookworm AS builder
#WORKDIR /build
#
## Rule 1: Caching Law (Download dependencies first)
#COPY pom.xml .
#COPY mvnw .
#COPY .mvn .mvn
#RUN ./mvnw dependency:go-offline -B
#
## Rule 1: Copy source code last, as it changes most often
#COPY src ./src
#RUN ./mvnw clean package -DskipTests
#
## Rule 3: Unpack your bags (Extract the fat JAR into layers)
## Note: For Spring Boot 3+, use the JarLauncher approach
#RUN java -Djarmode=layertools -jar target/*.jar extract
#
## ==========================================
## STAGE 2: THE DINING ROOM (Production Image)
## ==========================================
#FROM eclipse-temurin:25-jre-bookworm
#WORKDIR /app
#
## Rule 4: Least Privilege Law (Create a non-root user)
#RUN groupadd -r springgroup && useradd -r -g springgroup springuser
#USER springuser
#
## Rule 3: Copy the extracted layers from Stage 1.
## Order matters! Dependencies change least, application code changes most.
#COPY --from=builder /build/dependencies/ ./
#COPY --from=builder /build/spring-boot-loader/ ./
#COPY --from=builder /build/snapshot-dependencies/ ./
#COPY --from=builder /build/application/ ./
#
## Rule 5: Elastic Belt Law (Container-aware memory)
#ENV JAVA_OPTS="-XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=75.0 -XX:+UseG1GC"
#
## Execute using Spring Boot's optimized launcher class (for extracted layers)
#ENTRYPOINT exec java $JAVA_OPTS org.springframework.boot.loader.launch.JarLauncher









