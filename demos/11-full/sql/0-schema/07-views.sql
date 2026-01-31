CREATE OR REPLACE VIEW generalized_address AS
SELECT
    id,
    anon.generalize_int4range(postal_code::int, 100) AS postal_code
FROM address;

GRANT SELECT ON generalized_address TO stat;


CREATE OR REPLACE VIEW generalized_player AS
SELECT
    id,
    address_id,
    anon.dnoise(birthdate, INTERVAL '1 year') AS birthdate,
    anon.partial(email, 0, REPEAT('x', POSITION('@' IN email) - 1), LENGTH(email) - POSITION('@' IN email) + 1) as email,
    anon.ternary(anon.random_int_between(1,3) = 1,
                                        NULL,
                                        anon.partial(phone, 5,' XX XX XX XX', 0)) as phone
FROM player;

GRANT SELECT ON generalized_player TO stat;


CREATE OR REPLACE VIEW generalized_event AS
SELECT
    id,
    address_id,
    anon.generalize_tsrange(date, 'month') AS date
FROM event;

GRANT SELECT ON generalized_event TO stat;


CREATE OR REPLACE VIEW generalized_sponsor AS
SELECT
    id,
    address_id
FROM sponsor;

GRANT SELECT ON generalized_sponsor TO stat;


CREATE OR REPLACE VIEW generalized_participant AS
SELECT
    player_id,
    event_id
FROM participant;

GRANT SELECT ON generalized_participant TO stat;


CREATE OR REPLACE VIEW generalized_financing AS
SELECT
    event_id,
    sponsor_id,
    anon.generalize_int4range(amount::int, 100) AS amount
FROM financing;

GRANT SELECT ON generalized_financing TO stat;
