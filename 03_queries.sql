-- Queries for the OECD Economic Indicators project
-- Demonstrates filtering, aggregation, and window functions

-- =========================================================
-- Query 1: Top 10 highest inflation readings in the dataset
-- =========================================================
SELECT c.country_name, i.year, i.inflation_annual_pct
FROM indicators i
JOIN countries c ON i.country_code = c.country_code
WHERE i.inflation_annual_pct IS NOT NULL
ORDER BY i.inflation_annual_pct DESC
LIMIT 10;


-- =========================================================
-- Query 2: Average unemployment rate by country (highest first)
-- =========================================================
SELECT c.country_name, ROUND(AVG(i.unemployment_pct), 2) AS avg_unemployment
FROM indicators i
JOIN countries c ON i.country_code = c.country_code
GROUP BY c.country_name
ORDER BY avg_unemployment DESC
LIMIT 10;


-- =========================================================
-- Query 3: Year-over-year population change for Germany
-- (demonstrates the LAG window function)
-- =========================================================
SELECT 
    c.country_name,
    i.year,
    i.population_total,
    i.population_total - LAG(i.population_total) OVER (ORDER BY i.year) AS pop_change
FROM indicators i
JOIN countries c ON i.country_code = c.country_code
WHERE c.country_name = 'Germany'
ORDER BY i.year;


-- =========================================================
-- Query 4: Rank countries by inflation within each year
-- (demonstrates RANK with PARTITION BY)
-- =========================================================
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