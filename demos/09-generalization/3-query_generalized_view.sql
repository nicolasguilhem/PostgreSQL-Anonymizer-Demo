SELECT birth, postal_code
FROM generalized_players
JOIN generalized_address ON address_id = generalized_address.id
LIMIT 10;

SELECT
  EXTRACT(DECADE FROM AGE(LOWER(gp.birth)))::INT * 10 AS age,
  (LOWER(ga.postal_code) / 1000)::INT AS department,
  COUNT(gp.id) AS player_count
FROM generalized_players gp
JOIN generalized_address ga ON gp.address_id = ga.id
GROUP BY age, department
ORDER BY player_count DESC;