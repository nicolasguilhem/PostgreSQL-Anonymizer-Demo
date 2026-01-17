CREATE SCHEMA custom_masks;
GRANT USAGE ON SCHEMA custom_masks TO dev;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA custom_masks TO dev;

CREATE OR REPLACE FUNCTION custom_masks.participant_documents(j JSONB)
RETURNS JSONB
VOLATILE
LANGUAGE SQL
AS $func$
SELECT
    jsonb_set(
        jsonb_set(
            j,
            '{medical_certificate,doctor}',
            to_jsonb('Dr ' || anon.dummy_first_name() || ' ' || UPPER(anon.dummy_last_name()))
        ),
    '{medical_certificate,delivery_date}',
    to_jsonb(to_char(anon.random_date_between(CURRENT_DATE - INTERVAL '4 YEAR', CURRENT_DATE), 'YYYY-MM-DD"T"HH24:MI:SSTZH:TZM'))
    )
$func$;

SECURITY LABEL FOR anon ON FUNCTION custom_masks.participant_documents IS 'TRUSTED';

SECURITY LABEL FOR anon ON COLUMN participant.documents
  IS 'MASKED WITH FUNCTION custom_masks.participant_documents(participant.documents)';
