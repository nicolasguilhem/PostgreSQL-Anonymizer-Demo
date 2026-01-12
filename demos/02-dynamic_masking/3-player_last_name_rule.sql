SECURITY LABEL FOR anon ON COLUMN player.first_name
  IS 'MASKED WITH FUNCTION anon.dummy_first_name()';

SECURITY LABEL FOR anon ON COLUMN player.last_name
  IS 'MASKED WITH FUNCTION anon.dummy_last_name_locale($$fr_FR$$)';
