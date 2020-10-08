FROM alpine/git:latest AS clone 
#Descarga del repo alpine la carpeta git en su release latest (todo lo necesario para ejecutar el comando git) y la llamas clone (es RO)

ARG dir=clone-folder
ARG hostname=github.com
ARG username=ipuertas 
#asigna ipuertas a la vble username
ARG project=spring-petclinic
#asigna ipuertas a la vble username

WORKDIR /clone-folder 
#Crea una carpeta dentro del contenedor /clone-folder (vacía) y todo lo que se ejecute se hará dentro de esa carpeta (es RO: asi que crea otra carpeta que contiene lo que descarga y linux hara un merge entre todas. Habria que minimizar el num de lineas para mejorar el rendimiento: menos carpetas)

RUN git clone https://$hostname/$username/$project  
#ejecuta el comando git clone....

FROM maven:alpine AS build

# !! cada from tiene su espacio de variables
ARG dir=build-folder 
ARG from=clone
ARG dir_old=clone-folder 
ARG project=spring-petclinic

WORKDIR /$dir
COPY --from=$from /$dir_old/$project . 
RUN mvn install && mv target/$project-*.jar target/$project.jar

FROM openjdk:jre-alpine AS production
# descargo los binarios del jre a una carpeta llamada production
WORKDIR /production-folder
COPY --from=build_folder/target /production/target/spring-petclinic.jar .
ENTRYPOINT ["java","-jar"]
CMD ["spring-petclinic.jar"]
#marca que el entry point del contenedor es "java -jar spring-petclinic.jar"
# COMMENT
