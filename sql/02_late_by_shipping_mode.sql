-- Q: Which shipping modes are late most often, and why?
SELECT shipping_mode,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN is_late = 1 THEN order_id END)
             / COUNT(DISTINCT order_id), 1) AS late_pct,
       ROUND(AVG(days_for_shipping_real), 2) AS avg_real_days,
       ROUND(AVG(days_for_shipment_scheduled), 2) AS avg_scheduled_days
FROM orders
WHERE is_canceled = 0
GROUP BY shipping_mode
ORDER BY late_pct DESC;