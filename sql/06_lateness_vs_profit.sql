-- Q: Do late deliveries reduce profit?
SELECT is_late,
       COUNT(*) AS items,
       ROUND(AVG(order_profit_per_order), 2) AS avg_profit_per_item,
       ROUND(100.0 * SUM(order_profit_per_order) / SUM(sales), 1) AS margin_pct
FROM orders
WHERE is_canceled = 0
GROUP BY is_late;