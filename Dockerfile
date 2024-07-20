# This assume you have built the jar file with mvn clean package
FROM amazoncorretto:21 as build
WORKDIR /build
COPY target/*.jar .
RUN mkdir -p dependency && (cd dependency; jar -xf ../*.jar)

#FROM ghcr.io/valvoline-llc/vioc-amazoncorretto:21-alpine-latest
FROM amazoncorretto:21

ARG DEPENDENCY=/build/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

CMD ["java", "-cp", "app:app/lib/*", "com.example.demo_jrs.DemoJrsApplication"]
