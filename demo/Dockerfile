FROM eclipse-temurin:21-jre
WORKDIR /app
COPY target/*.jar demo-0.0.1.jar
EXPOSE 8008
ENTRYPOINT ["java","-jar","demo-0.0.1.jar"]