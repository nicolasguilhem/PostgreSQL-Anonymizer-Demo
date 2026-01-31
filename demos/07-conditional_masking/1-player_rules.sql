SECURITY LABEL FOR anon ON COLUMN player.email
  IS 'MASKED WITH FUNCTION anon.ternary(player.id > 5,
                                        anon.dummy_free_email_locale($$fr_FR$$),
                                        player.email::TEXT)';

SECURITY LABEL FOR anon ON COLUMN player.phone
  IS 'MASKED WITH FUNCTION anon.ternary(anon.random_int_between(1,3) = 1,
                                        NULL,
                                        anon.concat($$+ 33 $$, anon.substr(anon.dummy_phone_number_locale($$fr_FR$$),2)))';

SECURITY LABEL FOR anon ON TABLE player IS 'MASKED WHEN player.id > 5';
