SECURITY LABEL FOR anon ON COLUMN player.email
  IS 'MASKED WITH FUNCTION anon.pseudo_email(player.email)';

SECURITY LABEL FOR anon ON COLUMN player.first_name
  IS 'MASKED WITH FUNCTION anon.pseudo_first_name(player.first_name)';

SECURITY LABEL FOR anon ON COLUMN player.last_name
  IS 'MASKED WITH FUNCTION anon.pseudo_last_name(player.last_name, $$secrément salé$$)';
