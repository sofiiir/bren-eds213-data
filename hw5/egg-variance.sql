-- INVESTIGATING EGG VARIANCE ACROSS LONGITUDE

-- PART1 
-- STEP 1
-- view the three dataframes
SELECT * FROM Species LIMIT 5;
SELECT * FROM Nests_big LIMIT 5;
SELECT * FROM Eggs_big LIMIT 5;

-- STEP 2
-- join to relate egg measurements to species
-- select only for calidris alpina
SELECT * FROM Eggs_big AS E
  JOIN Nests_big AS N USING (Nest_ID)
  JOIN Species AS S ON N.Species =  S.Code
  WHERE Scientific_name = 'Calidris alpina';

-- STEP 3
-- calculate egg volume
SELECT Site, 3.14 * (Width * Width) * Length AS Volume
    FROM Eggs_big 
    JOIN Nests_big  USING (Nest_ID)
    JOIN Species ON Species = Code
    WHERE Scientific_name = 'Calidris alpina';

-- STEP 4
-- longitude and volume table
SELECT Longitude, Volume
    FROM (SELECT Site, (3.14/6) * (Width * Width) * Length AS Volume
    FROM Eggs_big AS E
    JOIN Nests_big AS N USING (Nest_ID)
    JOIN Species AS S ON N.Species =  S.Code
    WHERE Scientific_name = 'Calidris alpina')
    JOIN Site AS SI ON Site = SI.Code;

-- STEP 5
-- adjust the longitude to express its orientation to the meridian
SELECT CASE WHEN Longitude > 0 THEN Longitude - 360
    ELSE Longitude END AS Longitude, Volume
    FROM (SELECT Site, (3.14/6) * (Width * Width) * Length AS Volume
    FROM Eggs_big AS E
    JOIN Nests_big AS N USING (Nest_ID)
    JOIN Species AS S ON N.Species =  S.Code
    WHERE Scientific_name = 'Calidris alpina')
    JOIN Site AS SI ON Site = SI.Code;

-- STEP 6
-- create a view of the table with adjusted longitudes
CREATE VIEW Lon_vol AS
    SELECT CASE WHEN Longitude > 0 THEN Longitude - 360
    ELSE Longitude END AS Longitude, Volume
    FROM (SELECT Site, (3.14/6) * (Width * Width) * Length AS Volume
    FROM Eggs_big AS E
    JOIN Nests_big AS N USING (Nest_ID)
    JOIN Species AS S ON N.Species =  S.Code
    WHERE Scientific_name = 'Calidris alpina')
    JOIN Site AS SI ON Site = SI.Code;

-- make sure the case when worked 
SELECT Max(Longitude) FROM Lon_vol;
SELECT Min(Longitude) FROM Lon_vol;

-- STEP 7
-- calculate the linear regression
SELECT
    regr_slope(Volume, Longitude) AS Slope, 
    corr(Volume, Longitude) AS PCC 
    FROM Lon_vol;


-- PART2
-- 1. Do the tables created automatically by DuckDB guarantee 
-- that a nest ID mentioned in the Eggs_big table actually 
-- exists in the Nests_big table? If yes, explain how that
-- is guaranteed, if not, explain why not.
 The tables guarantee that the nest ID mentioned in the 
 Eggs_table are in the Nests_big table as well. The default JOIN in 
 SQL is an INNER JOIN. Therefore, the nest ID must be present 
 in both of the tables to be included in the output.

 -- 2. What queries did you use (or could you use) to find the 
 -- minimum and maximum longitude values in the Site table?
 To see the minimum longitude run: 
    SELECT Min(Longitude) FROM Site;

To see the maximum longitude run:
    SELECT Max(Longitude) FROM Site;

-- 3. The interpretation of the Pearson correlation coefficient is:
-- +1 is a perfect positive correlation, -1 is a perfect negative 
-- correlation, and 0 is no correlation at all. How would you characterize 
-- the correlation between egg volume and longitude for the eggs of 
-- Calidris alpina in the Arctic above Canada? 
The correlation value is just barely under zero at approximately 
-0.108. There is a weak negative correlation. As the longitude 
value increases there is a slight decrease in egg volume. 