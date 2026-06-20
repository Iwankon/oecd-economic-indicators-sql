-- Schema for OECD Economic Indicators project
-- Creates the two main tables: countries and indicators

CREATE TABLE countries (
country_code CHAR(3) PRIMARY KEY,
country_name VARCHAR(100) NOT NULL,
);

CREATE TABLE indicators (
country_code CHAR(3) REFERENCES countries(country_code),
year INT NOT NULL,
inflation_annual_pct NUMERIC(10,4),
unemployment_pct NUMERIC(10,4),
population_total BIGINT,
PRIMARY KEY (country_code, year)
);