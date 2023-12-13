FROM openjdk:17-oracle as builder
WORKDIR /opt/app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline
COPY ./src ./src
RUN ./mvnw clean package

FROM openjdk:17-oracle
ARG JAR_NAME=JAR_FILE_NAME
LABEL name="evaluator-service microservice" \
description="Docker image for evaluator-service microservice"
RUN mkdir -p /mnt/volume
WORKDIR /opt/app
EXPOSE 8080
ENV DB_URL=/mnt/volume/evaluator-db
ENV DB_USER=USER-SECRET
ENV DB_PW=PASSWORD-SECRET
ENV APP_PORT=8080
ENV AUTH0_ISSUER=ISSUER-SECRET
ENV AUTH0_AUDIENCE=AUDIENCE-SECRET
COPY --from=builder /opt/app/target/${JAR_NAME}.jar /opt/app/evaluator-service-api.jar
ENTRYPOINT ["java", "-jar", "/opt/app/evaluator-service-api.jar" ]