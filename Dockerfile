FROM postgres

ENV POSTGRES_DB=task
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

COPY /task_init.sql /docker-entrypoint-initdb.d