SELECT
  EXTRACT(DECADE FROM AGE(p.birthdate))::INT * 10 AS age,
  SUBSTRING(a.postal_code FROM 1 FOR 2) AS department,
  COUNT(p.id) AS player_count
FROM player p
JOIN address a ON p.address_id = a.id
GROUP BY age, department
ORDER BY player_count DESC;
