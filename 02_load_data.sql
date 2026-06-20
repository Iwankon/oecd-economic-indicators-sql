-- Loading and transforming data for the OECD Economic Indicators project

-- Step 1: Create a staging table matching the raw CSV structure
CREATE TABLE staging_oecd (
    country_code CHAR(3),
    country_name VARCHAR(100),
    year INT,
    inflation_annual_pct NUMERIC(10, 4),
    unemployment_pct NUMERIC(10, 4),
    population_total BIGINT
);

-- Step 2: Load oecd_indicators_clean.csv into staging_oecd here
-- (done via pgAdmin's Import/Export Data tool, not a SQL statement)

-- Step 3: Populate the countries table from staging
INSERT INTO countries (country_code, country_name)
SELECT DISTINCT country_code, country_name
FROM staging_oecd;

-- Step 4: Populate the indicators table from staging
INSERT INTO indicators (country_code, year, inflation_annual_pct, unemployment_pct, population_total)
SELECT country_code, year, inflation_annual_pct, unemployment_pct, population_total
FROM staging_oecd;