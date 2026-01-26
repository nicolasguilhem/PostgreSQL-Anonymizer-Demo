-- Table: Address
-- Stores physical addresses with GPS coordinates
-- Referenced by: Player, Event, Sponsor

CREATE TABLE IF NOT EXISTS address (
    id SERIAL PRIMARY KEY,
    street_number VARCHAR(10),
    street_name VARCHAR(255) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    city VARCHAR(100) NOT NULL,
    gps_coordinates POINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster lookups by postal code and city
CREATE INDEX idx_address_postal_code ON address(postal_code);
CREATE INDEX idx_address_city ON address(city);

-- Index for GPS coordinate searches
CREATE INDEX idx_address_gps ON address USING GIST(gps_coordinates);

COMMENT ON TABLE address IS 'Physical addresses with GPS coordinates';
COMMENT ON COLUMN address.street_number IS 'Street number';
COMMENT ON COLUMN address.street_name IS 'Street name';
COMMENT ON COLUMN address.postal_code IS 'Postal code';
COMMENT ON COLUMN address.city IS 'City/Municipality';
COMMENT ON COLUMN address.gps_coordinates IS 'GPS coordinates (Point type)';

GRANT SELECT ON TABLE address TO dev;

SECURITY LABEL FOR anon ON COLUMN address.city
  IS 'MASKED WITH FUNCTION anon.dummy_city_name_locale($$fr_FR$$)';

SECURITY LABEL FOR anon ON COLUMN address.street_name
  IS 'MASKED WITH FUNCTION anon.dummy_street_name_locale($$fr_FR$$)';

SECURITY LABEL FOR anon ON COLUMN address.postal_code
  IS 'MASKED WITH FUNCTION anon.dummy_zip_code_locale($$fr_FR$$)';

CREATE OR REPLACE FUNCTION anon.dummy_gps_point()
RETURNS POINT AS $$
BEGIN
  RETURN POINT(anon.dummy_longitude()::FLOAT, anon.dummy_latitude()::FLOAT);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

SECURITY LABEL FOR anon ON COLUMN address.gps_coordinates
  IS 'MASKED WITH FUNCTION anon.dummy_gps_point()';
