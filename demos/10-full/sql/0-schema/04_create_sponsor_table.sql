-- Table: Sponsor
-- Stores sponsor/partner information with business details

CREATE TABLE IF NOT EXISTS sponsor (
    id SERIAL PRIMARY KEY,
    address_id INTEGER,
    name VARCHAR(255) NOT NULL,
    siren VARCHAR(9) NOT NULL,
    logo BYTEA,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sponsor_address FOREIGN KEY (address_id) 
        REFERENCES address(id) ON DELETE SET NULL,
    CONSTRAINT chk_sponsor_siren CHECK (siren ~ '^[0-9]{9}$')
);

-- Indexes for common queries
CREATE INDEX idx_sponsor_name ON sponsor(name);
CREATE INDEX idx_sponsor_siren ON sponsor(siren);
CREATE INDEX idx_sponsor_address_id ON sponsor(address_id);

-- Unique constraint on SIREN (French business identification number)
CREATE UNIQUE INDEX idx_sponsor_siren_unique ON sponsor(siren);

COMMENT ON TABLE sponsor IS 'Sponsor/partner organization information';
COMMENT ON COLUMN sponsor.name IS 'Organization name';
COMMENT ON COLUMN sponsor.siren IS 'SIREN number (French business ID) - 9 digits';
COMMENT ON COLUMN sponsor.logo IS 'Company logo stored as binary data (BLOB)';

GRANT SELECT ON TABLE sponsor TO dev;
GRANT SELECT ON TABLE anon.siret TO dev;

SECURITY LABEL FOR anon ON COLUMN sponsor.name
    IS 'MASKED WITH FUNCTION anon.dummy_company_name_locale($$fr_FR$$)';

SECURITY LABEL FOR anon ON COLUMN sponsor.siren
    IS 'MASKED WITH FUNCTION anon.left(anon.replace(anon.fake_siret(),$$ $$, $$$$),9)';

SECURITY LABEL FOR anon ON COLUMN sponsor.logo
    IS 'MASKED WITH FUNCTION anon.image_blur(logo, 7.0)';

