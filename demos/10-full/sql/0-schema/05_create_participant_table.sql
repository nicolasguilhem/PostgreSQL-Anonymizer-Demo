-- Table: Participant
-- Junction table linking players to events
-- Stores JSONB supporting documents/proofs

CREATE TABLE IF NOT EXISTS participant (
    player_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    documents JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (player_id, event_id),
    CONSTRAINT fk_participant_player FOREIGN KEY (player_id) 
        REFERENCES player(id) ON DELETE CASCADE,
    CONSTRAINT fk_participant_event FOREIGN KEY (event_id) 
        REFERENCES event(id) ON DELETE CASCADE
);

-- Indexes for efficient queries
CREATE INDEX idx_participant_player_id ON participant(player_id);
CREATE INDEX idx_participant_event_id ON participant(event_id);

-- GIN index for JSONB queries on documents
CREATE INDEX idx_participant_supporting_docs ON participant USING GIN(documents);

COMMENT ON TABLE participant IS 'Junction table: players participating in events';
COMMENT ON COLUMN participant.player_id IS 'Reference to player';
COMMENT ON COLUMN participant.event_id IS 'Reference to event';
COMMENT ON COLUMN participant.documents IS 'Supporting documents/proofs stored as JSONB';

GRANT SELECT ON TABLE participant TO dev;

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
