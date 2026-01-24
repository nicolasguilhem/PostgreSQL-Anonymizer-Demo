CREATE OR REPLACE VIEW generalized_players AS
SELECT
    anon.random_id() as id,
    anon.generalize_tsrange(birthdate, 'decade') AS birth,
    address_id
FROM player;

CREATE OR REPLACE VIEW generalized_address AS
SELECT
    id,
    anon.generalize_int4range(postal_code::int, 100) AS postal_code
FROM address;
