FROM postgres

ENV POSTGRES_DB=user
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

COPY /user_init.sql /docker-entrypoint-initdb.d
