# DVD Rental Business Intelligence
### SQL Portfolio Project | Trey Mitchell
**B.S. Mathematics | Minor in Computer Science**

---

## Overview

SQL analysis of a DVD rental company using a 15 table
PostgreSQL database. The project covers data exploration, data quality auditing, revenue analysis, customer analytics, and film performance — framed around thought of real business questions a data analyst could answer on day one.

## Skills Demonstrated

* PostgreSQL
* SQL Joins
* Aggregate Functions
* Window Functions
* Data Quality Auditing
* Schema Validation
* Exploratory Data Analysis (EDA)
* Customer Analytics
* Revenue Analysis
* Business Intelligence Reporting
* Data Profiling
* Relational Database Design

---

## Key Numbers

* | Total Revenue | $61312.04 |
* | Total Customers | 599 |
* | Total Films | 1,000 |
* | Total Rentals | 16044 |
* | Top Customer LTV | Eleanor Hunt $211.55 |
* | Highest Revenue Category | Sports ($4892.19) |

---

## Project Structure

dvdrental-sql-analysis/
├── README.md
├── KEY_FINDINGS.md
├── Queries/
│   ├── 01_data_exploration.sql
│   └── 02_business_analytics.sql
└── screenshots/
    ├── erd_schema.png
    ├── row_counts.png
    ├── null_audit_rental.png
    ├── rentals_by_day.png
    ├── film_rating_distribution.png
    ├── total_revenue.png
    ├── revenue_by_month.png
    ├── revenue_by_store.png
    ├── top_20_customers.png
    ├── most_rented_films.png
    └── revenue_by_category.png

---

## Module 1 — Data Exploration & Schema Mapping
Profiled all 15 tables before any analysis to validate data quality and understand the schema.

- Row counts across all 15 tables
- Null audits on payment, rental, customer, and film tables
- Date range and cardinality checks
- Rental behavior patterns by day of week and hour
- Data quality flags: $0 payments, impossible dates, duplicate emails

---

## Module 2 — Business Analytics

**Revenue**
- Total company revenue
- Monthly revenue trend
- Revenue by stores 1 and 2

**Customer Analytics**
- Top 20 customers by lifetime value
- Average customer spend
- Full customer spending rank using RANK() window function

**Film Performance**
- Top 20 most rented films
- Top 20 highest revenue films
- Revenue breakdown by category

---

## Tools

| PostgreSQL | Database and query execution |
| pgAdmin 4 | GUI, query runner |
| Git + GitHub | Version control and portfolio |

---

## How to Run

1. Restore the dvdrental database:
```bash
   pg_restore -U postgres -d dvdrental dvdrental.tar
```
2. Open pgAdmin 4
3. Run each query in order: `01_data_exploration.sql` then `02_business_analytics.sql`

---

## Author

**Trey Mitchell**
B.S. Mathematics | Minor in Computer Science
GitHub: [your link] | LinkedIn: [your link]
