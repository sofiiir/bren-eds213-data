duckdb walkability.duckdb

INSTALL spatial;
LOAD spatial;

INSTALL httpfs;
LOAD httpfs;

-- load in the walkability fip data
CREATE TABLE Fips AS
    SELECT * FROM read_csv('https://apps.bren.ucsb.edu/eds213-data/walkability/fips_state_county.csv');

-- select the fips for california
SELECT * FROM Fips WHERE STATEFP = '06';

-- create a view of the walkability index for california
CREATE VIEW Walkability_ca AS
 SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, CBSA, CBSA_Name, TotPop, NatWalkInd, geom_wgs84
  FROM read_parquet('https://apps.bren.ucsb.edu/eds213-data/walkability/walkability_wgs84.parquet')
  WHERE STATEFP = '06';

  -- view tables 
  .tables

-- join the walkability and fip tables
CREATE VIEW Walkind_mystate AS
    SELECT * FROM Fips 
        JOIN Walkability_ca
        USING (COUNTYFP);

  -- view tables 
  .tables