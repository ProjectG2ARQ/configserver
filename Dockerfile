# Etapa 1: Build y empaquetado
FROM eclipse-temurin:25-jdk AS builder
WORKDIR /build

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw

COPY src/ ./src/
RUN ./mvnw clean package -DskipTests -Dmaven.test.skip=true

# Etapa 2: Imagen final de ejecución (Runtime)
FROM eclipse-temurin:25-jre-noble
WORKDIR /app

RUN groupadd -r spring && useradd -r -g spring spring
USER spring:spring

COPY --from=builder /build/target/*.jar app.jar

ENV PORT=8085
EXPOSE 8085

ENTRYPOINT ["java", "-Dspring.classformat.ignore=true", "-jar", "app.jar"]