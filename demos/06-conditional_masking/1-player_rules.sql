SECURITY LABEL FOR anon ON COLUMN player.email
  IS 'MASKED WITH FUNCTION anon.ternary(player.id > 5,
                                        anon.pseudo_email(player.email),
                                        player.email::TEXT)';

SECURITY LABEL FOR anon ON COLUMN player.phone
  IS 'MASKED WITH FUNCTION anon.ternary(anon.random_int_between(1,3) = 1,
                                        NULL,
                                        anon.random_phone($$+33 $$))';
