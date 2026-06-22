# OECD Economic Indicators — SQL Portfolio Project

A SQL project analyzing key macroeconomic indicators — inflation, unemployment, and population — across 38 OECD member countries from 1990 to 2016. Built to demonstrate practical SQL skills: schema design, data cleaning, joins, aggregations, and window functions.

## Data Source

Data comes from the **World Bank's World Development Indicators (WDI)** database:
- Inflation, consumer prices (annual %) — `FP.CPI.TOTL.ZG`
- Unemployment, total (% of labor force) — `SL.UEM.TOTL.ZS`
- Population, total — `SP.POP.TOTL`

Source: [World Development Indicators, The World Bank](https://databank.worldbank.org/source/world-development-indicators) — licensed under [CC BY-4.0](https://creativecommons.org/licenses/by/4.0/).

**Note on scope:** the analysis is capped at 1990–2016 because the World Bank's bulk inflation export only covers that range for several countries, and limiting all three indicators to the same window keeps every query and join consistent.

## Project Structure

| File | Description |
|---|---|
| `oecd_indicators_clean.csv` | Cleaned, merged dataset (1,026 rows: 38 countries × 27 years) |
| `01_schema.sql` | Creates the `countries` and `indicators` tables |
| `02_load_data.sql` | Loads the raw CSV into a staging table, then populates the two main tables |
| `03_queries.sql` | Analytical queries: filtering, aggregation, and window functions |

## Schema

Two normalized tables, linked by `country_code`:

```
countries
├── country_code (PK)
└── country_name

indicators
├── country_code (FK → countries.country_code)
├── year
├── inflation_annual_pct
├── unemployment_pct
└── population_total
(PK: country_code, year)
```

## Tools Used

- **PostgreSQL** for the database
- **pgAdmin 4** for schema creation, data loading, and query execution
- **Python (pandas)** for cleaning and merging the raw World Bank CSVs before loading

## Key Findings

**1. Post-communist transition economies show extreme early-1990s inflation.**
Poland's inflation hit **555% in 1990** — by far the highest figure in the dataset — driven by the shock-therapy price liberalization that followed the end of communist rule. Lithuania (410%, 1993), Latvia (243%, 1992), and Estonia (90%, 1993) show the same pattern across the Baltic states.

**2. Turkey shows chronic structural inflation through the 1990s.**
Turkiye appears five times in the dataset's top 10 highest-inflation country-years (1994–1998), consistently in the 80–106% range — reflecting its well-documented pre-2001 high-inflation economic structure.

**3. Spain and Greece have the highest average unemployment among OECD members (1990–2016).**
Spain averages **17.3%** and Greece **13.4%** unemployment over the period — both shaped heavily by the 2010s Eurozone debt crisis, on top of pre-existing structural unemployment issues.

**4. German reunification is visible directly in the population data.**
Using a `LAG()` window function to calculate year-over-year population change, Germany's population jumps by **+580,867** in 1991 — its largest single-year increase in the dataset — corresponding to formal reunification in October 1990.
**5. Spain's unemployment moving average lags the actual rate during the 2008–2013 crisis.**
A 3-year moving average (`AVG()` with a fixed window frame) smooths short-term noise but is structurally slow to track fast directional moves. During Spain's sharp unemployment rise in the Eurozone crisis years, the actual rate consistently ran ahead of its own moving average — illustrating the trade-off between smoothing and responsiveness in trend analysis.
## Example Query

Ranking countries by inflation within each year, using `RANK()` and `PARTITION BY`:

```sql
SELECT 
    i.year,
    c.country_name,
    i.inflation_annual_pct,
    RANK() OVER (PARTITION BY i.year ORDER BY i.inflation_annual_pct DESC) AS inflation_rank
FROM indicators i
JOIN countries c ON i.country_code = c.country_code
WHERE i.inflation_annual_pct IS NOT NULL
ORDER BY i.year, inflation_rank
LIMIT 20;
```

## Author

Built by [Iwankon](https://github.com/Iwankon) as a hands-on project for learning SQL and building a data analyst portfolio.
