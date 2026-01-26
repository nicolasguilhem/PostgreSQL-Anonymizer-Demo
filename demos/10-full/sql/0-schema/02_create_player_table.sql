-- Table: Player
-- Stores player information with PII that will be anonymized
-- Contains sensitive data: name, birthdate, email, phone number

CREATE TABLE IF NOT EXISTS player (
    id SERIAL PRIMARY KEY,
    address_id INTEGER,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    birthdate DATE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_player_address FOREIGN KEY (address_id) 
        REFERENCES address(id) ON DELETE SET NULL,
    CONSTRAINT chk_player_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_birthdate CHECK (birthdate < CURRENT_DATE)
);

-- Indexes for common queries
CREATE INDEX idx_player_last_name ON player(last_name);
CREATE INDEX idx_player_first_name ON player(first_name);
CREATE INDEX idx_player_email ON player(email);
CREATE INDEX idx_player_address_id ON player(address_id);

-- Unique constraint on email
CREATE UNIQUE INDEX idx_player_email_unique ON player(email);

COMMENT ON TABLE player IS 'Player information - contains PII for anonymization demo';
COMMENT ON COLUMN player.last_name IS 'Last name - PII';
COMMENT ON COLUMN player.first_name IS 'First name - PII';
COMMENT ON COLUMN player.birthdate IS 'Date of birth - PII';
COMMENT ON COLUMN player.email IS 'Email address - PII';
COMMENT ON COLUMN player.phone IS 'Phone number - PII';

GRANT SELECT ON TABLE player TO dev;

SECURITY LABEL FOR anon ON COLUMN player.last_name
  IS 'MASKED WITH FUNCTION anon.pseudo_last_name(player.last_name)';

SECURITY LABEL FOR anon ON COLUMN player.first_name
  IS 'MASKED WITH FUNCTION anon.pseudo_first_name(player.first_name)';

SECURITY LABEL FOR anon ON COLUMN player.birthdate
  IS 'MASKED WITH FUNCTION anon.dnoise(birthdate, INTERVAL $$1 year$$)';

SECURITY LABEL FOR anon ON COLUMN player.email
  IS 'MASKED WITH FUNCTION anon.pseudo_email(player.email)';

SECURITY LABEL FOR anon ON COLUMN player.phone
  IS 'MASKED WITH FUNCTION anon.ternary(anon.random_int_between(1,3) = 1,
                                        NULL,
                                        anon.concat($$+ 33 $$, anon.substr(anon.dummy_phone_number_locale($$fr_FR$$),2)))';

SECURITY LABEL FOR anon ON TABLE player IS 'MASKED WHEN player.id > 5';
