FROM gradle:8.5-jdk21-alpine AS build
WORKDIR /app

COPY gradlew gradlew.bat ./
COPY gradle ./gradle
COPY build.gradle settings.gradle ./
COPY src ./src

RUN chmod +x gradlew


RUN ./gradlew clean bootJar -x test --no-daemon


FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

RUN apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*

EXPOSE 8761


COPY --from=build /app/build/libs/eureka-server-*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]
