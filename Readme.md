# OSM2PGSQL Docker Image README

This Docker image is designed to simplify the process of importing OpenStreetMap data into a PostgreSQL database using the osm2pgsql tool.

## Quick Start

1. Build the Docker image: `docker build -t osm2pgsql .`
2. Run the image: `docker run osm2pgsql` 
   This will use the default values provided in the Dockerfile. To customize the execution, you can override the default environment variables and/or CMD.

## Environment Variables

    - `PBF_PATH`: The path to the OSM .pbf data file inside the container. Default: /data/data.osm.pbf
    - `LUA_SCRIPT_PATH`: The path to a Lua script for custom processing. Default: /scripts/script.lua
    - `PGHOST`: The host of the PostgreSQL server. Default: host.docker.internal
    - `PGUSER`: PostgreSQL user. Default: postgres
    - `PGPASSWORD`: PostgreSQL password. Default: password
    - `PGDATABASE`: The name of the PostgreSQL database. Default: osm_db

## Custom Execution

To use custom OSM data and Lua script, use the following command:

```bash
docker run -v $(pwd)/data:/data osm2pgsql -H host.docker.internal -U postgres -d osmberlin -O flex -S /data/filter.lua /data/berlin-latest.osm.pbf
```

Ensure that both berlin-latest.osm.pbf and filter.lua are located in the data directory in your current path.

## Notes

    - Ensure the PostgreSQL server is accessible from the Docker container. The default host host.docker.internal assumes a local PostgreSQL server when using Docker for Desktop.

    - Ensure you have initialized the PostgreSQL database with the PostGIS extension to handle spatial data.