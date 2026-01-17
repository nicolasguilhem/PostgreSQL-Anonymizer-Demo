SECURITY LABEL FOR anon ON COLUMN player.phone
  IS 'MASKED WITH FUNCTION anon.partial(player.phone, 5, $$ XX XX XX $$, 2)';
