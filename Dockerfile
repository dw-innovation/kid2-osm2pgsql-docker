FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y osm2pgsql wget gcc make cmake libboost-dev libboost-system-dev \
    libboost-filesystem-dev libexpat1-dev zlib1g-dev \
    libbz2-dev libpq-dev libgeos-dev libgeos++-dev libproj-dev lua5.3 liblua5.3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PBF_PATH=/data/data.osm.pbf
ENV LUA_SCRIPT_PATH=/data/filter.lua
ENV PGHOST=host.docker.internal
ENV PGUSER=postgres
ENV PGPASSWORD=password
ENV PGDATABASE=osm_db

ENTRYPOINT ["osm2pgsql"]
CMD ["-H", "$PGHOST", "-U", "$PGUSER", "-d", "$PGDATABASE", "--number-processes", "1", "-O", "flex", "$PBF_PATH", "-S", "$LUA_SCRIPT_PATH"]