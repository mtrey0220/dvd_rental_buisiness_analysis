# DVD Rental Business Knowledge | Trey Mitchell
# Key Findings

## Revenue
* Total company revenue ($61,312.04) across all transactions is retrievable in a single aggregation (SUM): baseline figure that anchors every downstream revenue comparison.
* Revenue is not evenly distributed across months. Monthly aggregation shows clear peak and trough periods, with revenue peaking in the months March and April (over $20000) with the month of May being an incomplete month in the dataset ($514.18), making March and February the true-peak-to-trough comparison. This essentially  informs us staffing, inventory, and promotional timing decisions for the business.
* The two stores generate almost equal revenue, but not quite. The 2 store breakdown shows a measurable gap between locations, suggesting differences in foot traffic, inventory depth, or staff performance that warrant further investigation. Store 1 generating a total revenue of $30252.12 and Store 2 generating 31059.92.

## Customers
* The top 20 customers by lifetime value represent a disproportionate share of total revenue — We have Eleanor Hunt who was the top spender with $211.55 (#1) and then at the bottom of the list we have Guy Brownlee who spent a total of $151.69 (#20). Retaining these customers should be a top priority.
* Average customer spend provides a clear benchmark. Customers above this threshold are candidates for loyalty programs; those below it are targets for upsell campaigns. For our dvdrental database the average customer spend came out to $102.36.
* RANK() over total spend surfaces the full customer value hierarchy, enabling immediate segmentation, showing us that customer_id 148 had the #1 spending rank while customer_id 318 had the #599 spending rank.

## Film Performance
*	Rental volume and revenue do not always align. The top 20 rented films all had 30 or more rentals. The most-rented film was Bucket Brotherhood with 34 rentals, while the 20th rented film was Rugrats Shakespeare with 30. On the other hand, the film that generated the most revenue was Telegraph Voyage with $215.75 generated, while the 20th film that created the most revenue was Sunrise League generating $155.78.
* Category-level revenue reveals which genres drive the most income for the business. High-revenue categories from the dvdrental database were Sports, Sci-Fi, and Animation while Low-Revenue Categories were Children, Travel, and Music. High-revenue categories should be prioritized in inventory stocking and marketing.
* Some films have high rental counts but lower revenue, suggesting they are popular lower-rate titles. Others have fewer rentals but higher revenue per transaction, indicating premium pricing power.

## Data Quality (Module 1)
* return_date IS IN FACT NULL in the rental table (expected behavior) — these represent currently checked-out films, not missing data. According to the Null Audit of rental, there are currently 183 checked-out films
* There are still some inactive customers — According to the data there are 584 Active customers and 15 inactive customers.
* Rentals by Day of the Week — Data shows Tuesday being the day for the most rental sales while Thursday was the day for the least rental sales.
* Rentals by Month of the Year — Data shows July, 2005  being the Peak month for rentals with 6709 films rented, while February, 2006 was the low point with only 182 films rented.
* 0 payment records exist in the payment table and should be filtered or investigated before any revenue aggregation.
* No duplicate emails were found in the customer table, indicating clean customer identity data.

### Analytical Approach
Each query was written to answer a specific business question by myself, rather than demonstrating syntax. The first module was completed before any analysis to validate data quality assumptions.
All queries are written in standard PostgreSQL and are reproducible on any restore of the dvdrental database.
