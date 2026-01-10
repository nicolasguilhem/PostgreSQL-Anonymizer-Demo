FROM postgres:17

# Set environment variables
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=postgres

# Expose PostgreSQL port
EXPOSE 5432

RUN apt update \
  && apt install -y --no-install-recommends curl lsb-release ca-certificates
