SELECT
  ROUND(AVG(f.amount), 2) AS average_amount,
  SUBSTRING(a.postal_code FROM 1 FOR 2) AS department,
  EXTRACT(DECADE FROM e.date) * 10 AS event_year,
  COUNT(e.id) AS event_count
FROM event e
JOIN address a ON a.id = e.address_id
JOIN financing f ON f.event_id = e.id
GROUP BY department, event_year
ORDER BY department, event_year, average_amount DESC;
