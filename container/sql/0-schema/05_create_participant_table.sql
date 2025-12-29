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
