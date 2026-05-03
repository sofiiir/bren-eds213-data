-- INVESTIGATING EGG VARIANCE ACROSS LONGITUDE

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
    FROM (SELECT Site, 3.14 * (Width * Width) * Length AS Volume
    FROM Eggs_big AS E
    JOIN Nests_big AS N USING (Nest_ID)
    JOIN Species AS S ON N.Species =  S.Code
    WHERE Scientific_name = 'Calidris alpina')
    JOIN Site AS SI ON Site = SI.Code;

-- STEP 5
-- adjust the longitude to express its orientation to the meridian
SELECT CASE WHEN Longitude > 0 THEN Longitude - 360
    ELSE Longitude END AS Longitude, Volume
    FROM (SELECT Site, 3.14 * (Width * Width) * Length AS Volume
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
    FROM (SELECT Site, 3.14 * (Width * Width) * Length AS Volume
    FROM Eggs_big AS E
    JOIN Nests_big AS N USING (Nest_ID)
    JOIN Species AS S ON N.Species =  S.Code
    WHERE Scientific_name = 'Calidris alpina')
    JOIN Site AS SI ON Site = SI.Code;

-- STEP 7
-- calculate the linear regression
SELECT
    regr_slope(Volume, Longitude) AS Slope, 
    corr(Volume, Longitude) AS PCC 
    FROM Lon_vol;