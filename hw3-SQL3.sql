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
    SELECT Species, MAX(Avg_volume) AS max_avg_vol
    FROM Bird_nests JOIN Averages Using (Nest_ID)
    GROUP BY SPECIES;

-- add species names to the max_avg_vol table
 SELECT Species.Common_name, Max_avg_vol.max_avg_vol
    FROM Species JOIN max_avg_vol 
    ON Species.Code = Max_avg_vol.Species; 


-- list by species in descending order of max volume

