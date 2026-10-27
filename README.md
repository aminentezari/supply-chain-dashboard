# Supply Chain Performance Dashboard

Analysis of 180,000 order lines from the DataCo Smart Supply Chain dataset. The project looks at where and why orders are delivered late, and which products and regions drive profit.

Tools: Python (pandas), SQL (SQLite), Power BI.

![Dashboard](powerbi/dashboard.png)

## Business question

Where and why are orders delivered late, and which products and regions drive profit?

## Key findings

1. **Delays are caused by the delivery promise, not by the region.** 57.3% of shipped orders arrive late. First Class is 100% late because it promises 1 day and takes 2. Second Class promises 2 days and takes about 4, and is 80% late. Standard Class promises 4 days, delivers in about 4, and is late 39.8% of the time.
2. **Geography does not explain lateness.** The late rate is between 56.5% and 57.7% in all five markets. The highest regions (Central Africa 60.0%, East Africa 59.1%) have fewer than 600 orders each, so those rates are less reliable.
3. **Lateness is stable over time.** The monthly late rate stays in a narrow band around the overall average of 57.3%, so there is no worsening trend.
4. **Profit is concentrated.** 8 of 50 product categories (class A) generate 84.6% of total profit. Fishing alone is 19.2% (731k).
5. **Margins are flat.** Almost every category has a margin of 10% to 13%, so profit follows sales volume. Two weak categories: Strength Training (54.5k sales, 244 profit, 0.4% margin) and Men's Clothing (4.4% margin).
6. **Europe and LATAM lead profit.** Europe makes 1.13M and LATAM 1.07M, out of a total of 3.81M. Overall margin is 10.8%.
7. **Late delivery costs little margin in this data.** Margin is 10.6% on late items and 11.0% on on-time items. The dataset is synthetic, so this should not be read as a real-world rule.

## Suggested action

Set realistic delivery promises. If First Class promised 2 days and Second Class promised 4, most late orders in these two modes would count as on time, without changing the carrier.

## Dashboard contents

- KPI cards: total orders (62,897), late orders (36,048), on-time % (42.7%), profit margin (10.8%)
- Late % by shipping mode
- Promised vs real delivery days by shipping mode
- Sales and profit by market
- Late % by month
- ABC analysis of profit by category (Pareto chart)
- Slicers: shipping mode, market, order year, ABC class

## Project structure

```
supply-chain-dashboard/
  data/
    raw/            original Kaggle files (not in the repo)
    clean/          cleaned data and dashboard_data.csv
  notebooks/
    01_exploration.ipynb
    02_cleaning.ipynb
    03_sql_load.ipynb
  sql/              7 business queries (01 to 07)
  powerbi/          dashboard (.pbix), PDF export and screenshot
  README.md
```

## Method

**1. Exploration (Python).** The raw file has 180,519 rows and 53 columns, but only 65,752 unique orders, because each row is one order item. Dates were stored as text.

**2. Cleaning (Python).**
- Dropped personal data columns (email, first and last name, password, street, zip code) and columns that were empty or not useful (product description, product image, order zip code).
- Converted order and shipping dates to real dates.
- Created `delay_days` (real days minus promised days), `is_late`, `is_canceled`, `order_year` and `order_month`.
- Renamed columns to snake_case.

**3. SQL analysis (SQLite).** Seven queries, saved in `sql/`:

| File | Question |
|---|---|
| 01_overall_late_pct.sql | Share of shipped orders delivered late |
| 02_late_by_shipping_mode.sql | Late rate and promised vs real days by shipping mode |
| 03_late_by_market_region.sql | Late rate by market and region |
| 04_sales_profit_by_market.sql | Sales, profit and margin by market |
| 05_profit_by_category.sql | Profit and margin by category |
| 06_lateness_vs_profit.sql | Profit on late vs on-time items |
| 07_abc_analysis.sql | ABC classification of categories by profit |

**4. Dashboard (Power BI).** Built from `dashboard_data.csv`, a CSV prepared in SQL with canceled orders removed and the ABC class attached to each row.

## Decisions and definitions

- **Canceled shipments are excluded.** 7,754 rows have the delivery status "Shipping canceled" (order status CANCELED or SUSPECTED_FRAUD). They have no real delivery, so they are removed from all delivery and profit analysis. This leaves 172,765 rows and 62,897 unique orders.
- **Orders, not rows.** Late rates in SQL are calculated on unique order ids. All items in the same order have the same late flag (checked: 0 orders with mixed flags).
- **Small differences between SQL and Power BI.** Power BI averages the late flag over rows, so its percentages differ slightly from the order-based SQL results (for example Same Day: 47.9% in Power BI, 48.4% in SQL). The overall order-based figure is 57.3%.
- **Late flag.** `is_late` is 1 only when the delivery status is "Late delivery".
- **ABC rule.** Categories are ranked by profit. Class A is the smallest set of top categories needed to reach 80% of total profit (the category that crosses 80% is included). Class B goes up to 95%. Class C is the rest. Result: 8 categories in A, 10 in B, 32 in C.
- **Profit.** Profit uses `order_profit_per_order` summed over items. This was checked against profit ratio times item total (3.806M vs 3.813M, a 0.16% difference).

## Limitations

- The dataset is synthetic. Some fields are not logically consistent (for example, orders with status PENDING already have a delivery result), so the findings show analysis method rather than real company performance.
- No cost data for late deliveries (refunds, complaints, lost customers), so the effect of lateness on profit is only measured through margin.
- Small regions have few orders, so their percentages are less reliable.

## How to reproduce

1. Download the dataset from Kaggle: https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis/data
2. Put `DataCoSupplyChainDataset.csv` in `data/raw/`.
3. Install the packages: `pip install pandas numpy matplotlib seaborn ipykernel`
4. Run the notebooks in order: `01_exploration`, `02_cleaning`, `03_sql_load`.
5. Open `powerbi/supply_chain_dashboard.pbix` in Power BI Desktop (Windows) and point the data source to `data/clean/dashboard_data.csv`. A PDF export is also in `powerbi/`.

## Data source

DataCo Smart Supply Chain for Big Data Analysis, Kaggle.

## Author

Amin Entezari, MSc Data Science, University of Milano-Bicocca
GitHub: https://github.com/aminentezari
