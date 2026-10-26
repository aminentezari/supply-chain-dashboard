-- Q: Do some markets or regions have more late orders?
SELECT market,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_late = 1 THEN order_id END)
             / COUNT(DISTINCT order_id), 1) AS late_pct
FROM orders
WHERE is_canceled = 0
GROUP BY market
ORDER BY late_pct DESC;

SELECT order_region,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_late = 1 THEN order_id END)
             / COUNT(DISTINCT order_id), 1) AS late_pct
FROM orders
WHERE is_canceled = 0
GROUP BY order_region
ORDER BY late_pct DESC
LIMIT 5;