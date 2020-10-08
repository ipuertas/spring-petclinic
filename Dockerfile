FROM alpine/git:latest AS clone 
#Descarga del repo alpine la carpeta git en su release latest (todo lo necesario para ejecutar el comando git) y la llamas clone (es RO)

ARG hostname=github.com
ARG username=ipuertas 
#asigna ipuertas a la vble username
ARG project=spring-petclinic #asigna ipuertas a la vble username

WORKDIR /clone-folder 
#Crea una carpeta dentro del contenedor /clone-folder (vacía) y todo lo que se ejecute se hará dentro de esa carpeta (es RO: asi que crea otra carpeta que contiene lo que descarga y linux hara un merge entre todas. Habria que minimizar el num de lineas para mejorar el rendimiento: menos carpetas)

RUN git clone https://$hostname/$username/$project  
#ejecuta el comando git clone....

FROM maven:alpine AS build
WORKDIR /app2
COPY --from=clone /app1/spring-petclinic . 
RUN mvn install && mv target/spring-petclinic-*.jar target/spring-petclinic.jar

FROM openjdk:jre-alpine AS production
WORKDIR /app3
COPY --from=build /app2/target/spring-petclinic.jar .
ENTRYPOINT ["java","-jar"]
CMD ["spring-petclinic.jar"]

# COMMENT
