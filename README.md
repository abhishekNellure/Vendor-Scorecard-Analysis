Vendor Scorecard Analysis
This project analyzes vendor purchase order data to calculate key performance metrics — total spend, order volume, and on time delivery percentage and flags vendors whose delivery reliability falls below an acceptable threshold.
Dataset: 500 purchase orders across 10 vendors and 5 categories, covering orders placed between January and July 2026.
What's in this repo
`vendor_scorecard_analysis.ipynb` Python (Pandas) notebook. Loads the data, calculates the scorecard (spend, order count, on-time %, performance flag), and visualizes results with charts.
`vendor_scorecard_queries.sql` SQL queries covering the same analysis: filtering, GROUP BY/HAVING, CASE WHEN, JOINs with a vendor reference table, subqueries/CTEs, and window functions (RANK, PARTITION BY).
`vendor_dashboard.pbix` Power BI dashboard with an interactive bar chart, a DAX measure for on-time delivery %, a category slicer, and a total spend KPI card. Requires Power BI Desktop (free) to open.
Key metrics calculated
Total Spend sum of all purchase order amounts per vendor
Total Orders count of purchase orders placed
On-Time % percentage of orders delivered on time
Performance Flag vendors below 80% on-time delivery are flagged "Needs Improvement"
Summary of findings
Acme Supplies had the highest total spend (₹39.0L) while maintaining an acceptable 80.6% on time rate.
MetroSupplies combined high spend (₹32.4L) with the weakest on-time performance (61.8%) the highest operational risk in the dataset.
BrightTech was the most reliable vendor overall (87.2% on-time).
Tools used
SQL Server (SSMS) Python (Pandas, Matplotlib) Power BI (DAX, Data Visualization)
