CREATE OR REPLACE VIEW generalized_financing AS
SELECT
    event_id,
    anon.generalize_int4range(amount::int, 100) AS amount
FROM financing;

CREATE OR REPLACE VIEW generalized_address AS
SELECT
    id,
    anon.generalize_int4range(postal_code::int, 100) AS postal_code
FROM address;

CREATE OR REPLACE VIEW generalized_event AS
SELECT
    id,
    address_id,
    anon.generalize_tsrange(date, 'month') AS date
FROM event;
