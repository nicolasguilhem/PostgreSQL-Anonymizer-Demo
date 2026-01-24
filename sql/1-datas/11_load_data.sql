-- Load CSV data into PostgreSQL tables
-- This script uses COPY commands to efficiently import CSV files
-- Execute from the container or ensure file paths are accessible to PostgreSQL

-- Load address data
\COPY address(id, street_number, street_name, postal_code, city, gps_coordinates, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/01_address.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Load player data
\COPY player(id, address_id, last_name, first_name, birthdate, email, phone, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/02_player.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Load event data
\COPY event(id, address_id, name, description, date, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/03_event.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Load sponsor data
\COPY sponsor(id, address_id, name, siren, logo, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/04_sponsor.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Load participant data (junction table: player-event)
\COPY participant(player_id, event_id, documents, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/05_participant.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Load financing data (junction table: event-sponsor)
\COPY financing(event_id, sponsor_id, amount, created_at, updated_at) FROM '/docker-entrypoint-initdb.d/06_financing.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Update sponsor logos with image files (cyclic pattern: 1-10 repeat)
-- Each sponsor ID is assigned a logo based on: ((id - 1) % 10) + 1
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/1.jpg') WHERE (id - 1) % 10 = 0;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/2.jpg') WHERE (id - 1) % 10 = 1;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/3.jpg') WHERE (id - 1) % 10 = 2;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/4.jpg') WHERE (id - 1) % 10 = 3;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/5.jpg') WHERE (id - 1) % 10 = 4;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/6.jpg') WHERE (id - 1) % 10 = 5;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/7.jpg') WHERE (id - 1) % 10 = 6;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/8.jpg') WHERE (id - 1) % 10 = 7;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/9.jpg') WHERE (id - 1) % 10 = 8;
UPDATE sponsor SET logo = pg_read_binary_file('/docker-entrypoint-initdb.d/sponsor_logos/10.jpg') WHERE (id - 1) % 10 = 9;

-- Update sequences to match the imported data
SELECT setval('address_id_seq', (SELECT MAX(id) FROM address));
SELECT setval('player_id_seq', (SELECT MAX(id) FROM player));
SELECT setval('event_id_seq', (SELECT MAX(id) FROM event));
SELECT setval('sponsor_id_seq', (SELECT MAX(id) FROM sponsor));
