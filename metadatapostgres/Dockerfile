FROM postgres

ENV POSTGRES_DB=metadata
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

COPY /metadata_init.sql /docker-entrypoint-initdb.d
