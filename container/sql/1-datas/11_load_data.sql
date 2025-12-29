-- Load CSV data into PostgreSQL tables
-- This script uses COPY commands to efficiently import CSV files
-- Execute from the container or ensure file paths are accessible to PostgreSQL

-- Load address data
\COPY address(id, street_number, street_name, postal_code, city, gps_coordinates, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/01_address.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Load player data
\COPY player(id, address_id, last_name, first_name, birthdate, email, phone, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/02_player.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Load sponsor data
\COPY sponsor(id, address_id, name, siren, logo, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/04_sponsor.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Update sequences to match the imported data
SELECT setval('address_id_seq', (SELECT MAX(id) FROM address));
SELECT setval('player_id_seq', (SELECT MAX(id) FROM player));
SELECT setval('sponsor_id_seq', (SELECT MAX(id) FROM sponsor));
