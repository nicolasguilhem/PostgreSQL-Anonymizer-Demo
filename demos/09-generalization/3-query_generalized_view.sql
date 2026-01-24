SELECT amount, e.date, a.postal_code
FROM generalized_financing f
INNER JOIN generalized_event e ON e.id = f.event_id
INNER JOIN generalized_address a ON e.address_id = a.id;

SELECT
  ROUND(AVG(LOWER(f.amount)), 2) AS average_amount,
  (LOWER(a.postal_code) / 1000)::INT AS department,
  EXTRACT(DECADE FROM LOWER(e.date)) * 10 AS event_year,
  COUNT(e.id) AS event_count
FROM generalized_financing f
INNER JOIN generalized_event e ON e.id = f.event_id
INNER JOIN generalized_address a ON e.address_id = a.id
GROUP BY department, event_year
ORDER BY department, event_year, average_amount DESC;
