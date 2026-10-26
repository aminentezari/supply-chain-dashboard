-- Q: What share of shipped orders are delivered late?
SELECT COUNT(DISTINCT order_id) AS orders,
       COUNT(DISTINCT CASE WHEN is_late = 1 THEN order_id END) AS late_orders,
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_late = 1 THEN order_id END)
             / COUNT(DISTINCT order_id), 1) AS late_pct
FROM orders
WHERE is_canceled = 0;