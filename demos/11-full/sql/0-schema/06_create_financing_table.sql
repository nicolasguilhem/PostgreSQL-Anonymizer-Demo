-- Table: Financing
-- Junction table linking events to sponsors
-- Tracks financial amounts contributed by sponsors

CREATE TABLE IF NOT EXISTS financing (
    event_id INTEGER NOT NULL,
    sponsor_id INTEGER NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (event_id, sponsor_id),
    CONSTRAINT fk_financing_event FOREIGN KEY (event_id) 
        REFERENCES event(id) ON DELETE CASCADE,
    CONSTRAINT fk_financing_sponsor FOREIGN KEY (sponsor_id) 
        REFERENCES sponsor(id) ON DELETE CASCADE,
    CONSTRAINT chk_financing_amount CHECK (amount >= 0)
);

-- Indexes for efficient queries
CREATE INDEX idx_financing_event_id ON financing(event_id);
CREATE INDEX idx_financing_sponsor_id ON financing(sponsor_id);
CREATE INDEX idx_financing_amount ON financing(amount);

COMMENT ON TABLE financing IS 'Junction table: sponsors financing events';
COMMENT ON COLUMN financing.event_id IS 'Reference to event being financed';
COMMENT ON COLUMN financing.sponsor_id IS 'Reference to sponsor providing financing';
COMMENT ON COLUMN financing.amount IS 'Amount of financial contribution (in euros)';

GRANT SELECT ON TABLE financing TO dev;

SECURITY LABEL FOR anon ON FUNCTION pg_catalog.round(v numeric, s int) IS 'TRUSTED';

SECURITY LABEL FOR anon ON COLUMN financing.amount
  IS 'MASKED WITH FUNCTION pg_catalog.round(anon.random_in_numrange($$[0,1000]$$), 2)';
