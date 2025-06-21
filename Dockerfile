#
# BUILD STAGE
#
FROM maven:3.9.9-amazoncorretto-21-debian AS build  
COPY src /usr/src/app/src  
COPY pom.xml /usr/src/app  
RUN mvn -f /usr/src/app/pom.xml clean package

#
# PACKAGE STAGE
#
FROM openjdk:11-jre-slim 
COPY --from=build /usr/src/app/target/my-app-1.0-SNAPSHOT.jar /usr/app/my-app-1.0-SNAPSHOT.jar
EXPOSE 8081
CMD ["java","-jar","/usr/app/my-app-1.0-SNAPSHOT.jar"]  
