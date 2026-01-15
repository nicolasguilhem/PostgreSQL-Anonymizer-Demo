-- Table: Event
-- Stores event information with details and location

CREATE TABLE IF NOT EXISTS event (
    id SERIAL PRIMARY KEY,
    address_id INTEGER,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_event_address FOREIGN KEY (address_id) 
        REFERENCES address(id) ON DELETE SET NULL
);

-- Indexes for common queries
CREATE INDEX idx_event_name ON event(name);
CREATE INDEX idx_event_date ON event(date);
CREATE INDEX idx_event_address_id ON event(address_id);

COMMENT ON TABLE event IS 'Event information with location and timing';
COMMENT ON COLUMN event.name IS 'Event name/label';
COMMENT ON COLUMN event.description IS 'Detailed event description';
COMMENT ON COLUMN event.date IS 'Event date and time';
