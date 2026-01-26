FROM postgres:17

# Set environment variables
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=postgres

# Expose PostgreSQL port
EXPOSE 5432

# Update package lists and install dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      wget \
 && rm -rf /var/lib/apt/lists/*

# Install anon extension
RUN wget https://gitlab.com/api/v4/projects/7709206/packages/generic/deb/2.5.1/postgresql_anonymizer_pg17-2.5.1.amd64.deb \
 && dpkg -i postgresql_anonymizer_pg17-2.5.1.amd64.deb

# init script
RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./container/init_anon.sh /docker-entrypoint-initdb.d/00_init_anon.sh

COPY ./sql/0-schema/ /docker-entrypoint-initdb.d/

COPY ./sql/1-datas/ /docker-entrypoint-initdb.d/
