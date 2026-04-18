-- CONSTRUCT A SQL EXPERIMENT TO TEST HOW SQL HANDLES NULLS 
-- take a subset of the bird_eggs table
CREATE TABLE bird_eggs_subset AS 
SELECT * FROM bird_eggs
LIMIT 10; -- select only 15 rows

-- view the subset dataframe
SELECT * FROM bird_eggs_subset;

-- replace anywhere theres a 1 with NULL
UPDATE bird_eggs_subset
SET Egg_num = NULL 
WHERE Egg_num < 2;

-- make sure we have NULLs
SELECT * FROM bird_eggs_subset;

-- let's investigate what AVG does when there are NULLS
SELECT AVG(Egg_num) FROM bird_eggs_subset;
-- the AVG function ignores all of the NULLS 
-- specifically it divides the sum of all of the non-NULLS by the number of non-NULL values
-- it ignores that these rows exist

-- if we want to take the average interpretting the NULLs as zeros
SELECT SUM(Egg_num) /COUNT(*) FROM bird_eggs_subset;

-- since we're done with this table
DROP TABLE bird_eggs_subset;