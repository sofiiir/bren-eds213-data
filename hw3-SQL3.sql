-- list the scientific names of bird species in descending order of their mac average egg volumes

-- compute the average volume of the eggs in each nest
-- the equation for volume of an egg is (3.14/6) * W ^2 * L
CREATE TEMP TABLE Averages AS
    SELECT Nest_ID, AVG((3.14/6) * Width ^2 * Length) AS Avg_volume
    FROM Bird_eggs
    GROUP BY Nest_ID;

-- join the average table with the bird nests table
-- compute the max of the average volumes for each species
CREATE TEMP TABLE Max_avg_vol AS
    SELECT Species, MAX(Avg_volume) AS Max_avg_vol
    FROM Bird_nests JOIN Averages Using (Nest_ID)
    GROUP BY SPECIES;

-- add species names to the max_avg_vol table
 SELECT S.Scientific_name, MAV.Max_avg_vol
    FROM Species S JOIN Max_avg_vol MAV
    ON S.Code = MAV.Species; 


-- list by species in descending order of max volume
 SELECT S.Scientific_name, MAV.Max_avg_vol
    FROM Species S JOIN Max_avg_vol MAV
    ON S.Code = MAV.Species
    ORDER BY max_avg_vol DESC; 
