FROM openjdk:17-jdk-slim

WORKDIR /app

# Copier le JAR
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port
EXPOSE 8080

# Lancer l'application
CMD ["java", "-jar", "app.jar"]
