-- Filteriung
-- looks just like R or python
SELECT * FROM Site WHERE Area < 200;
SELECT * FROM Site WHERE Area < 200 AND Latitude > 60;

-- order style operators
SELECT * FROM Site WHERE Code != 'iglo';
SELECT * FROM Site WHERE Code <> 'iglo'; -- order style
-- expersion:

## Experssion
SELECT Site_name, Area*2.47 FROM Site;
-- Very handy to give a name to columns
SELECT Site_name, Area*2.47 AS Area_acres FROM Site;

-- String concatentation
-- old style operators: ||
SELECT Site_name || ', ' || Location AS Full_name Site;
-- There is probab;y other operators
SElECT Site_name + Location FROM Site;

## AGGREGATION & GROUPING

-- How many rows are in this table?
SELECT COUNT(*) FROM Bird_nests;
-- the "*" in the above mean, just count rows
-- we can also ask, how non-NULL values are there?
SELECT COUNT(*) FROM Species;
SELECT COUNT(Scientific_name) FROM Species;

--Very handy to count number of distinct things
SELECT COUNT(*) FROM Site; -- just an idiom, it doesn't make much sense
SELECT COUNT(DISTINCT Location) FROM Site; -- number of distinct locations
SELECT COUNT(Location) FROM Site; -- number of non-NULL locations
-- reminder from Monday
SELECT DISTINCT Location FROM Site;

-- The usual aggregation function 
SELECT AVG(Area) FROM Site;
SELECT MIN(Area) FROM Site;

-- This won't work but suppose we want to list the 7 location 
-- that occue in the Site table, along with the average are
SELECT Location, AVG(Area) FROM Site;

-- enter grouping
SELECT Location, AVG(Area) FROM Site GROUP BY Location;
-- similar for counting
SELECT Location, COUNT(*) FROM Site GROUP BY Location;
-- for comparison
-- Site |> group_by(Location) |> summarize(count = n())

-- We can still have WHERE clauses
SELECT Location, COUNT(*) 
    FROM Site 
    WHERE Location LIKE '%Canada' -- old style pattern matching, NOT full regex, just wildcard (%)
    GROUP BY Location;

    -- the order of the clauses reflect the order of the processing
    -- But, what if you want to do some filtering on your groups, i.e., *after* you've done the grouping
    SELECT Location, Max(Area) AS Max_area
        FROM Site
        WHERE Location LIKE '%Canada'
        GROUP BY Location
        HAVING Max_area > 200
        ORDER BY Max_area DESC;

## RELATIONAL ALGEBRA
-- Everything is a table
-- Every query, every statement actually returns a table
SELECT COUNT(*) FROM Site; -- COUNT(*) number of rows
-- you can save tables, you can nest queries
SELECT COUNT(*) FROM (SELECT COUNT(*) FROM Site);

-- you can nest queries
SELECT DISTINCT Species FROM Bird_nests;
-- how many birds are there no nest observations for
SELECT Code FROM Species 
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

## NULL processing
-- NULL is infectious
-- In a table, NULL mean no data, the absece of a value
-- In an expression, NULL means unknown
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = 'float';
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod <> 'float';
-- all the NULL rows are interpreted as unknown

-- This won't work , but you will try it by accident anyway
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = NULL;
-- THE ONLY WAY
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NULL;
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NOT NULL;
--so-called "tri-value" logic

--JOINS
-- 90% of the time we'll join tables based on a foreign key relationship
SELECT * FROM Camp_assignment;
SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 10;

-- join is a very general operation, can be applied to any tables, with any expression joining them
-- fundamentally, joins always start from Cartesian product of the table
-- CROSS JOIN = Cartesian product
SELECT * FROM Site CROSS JOIN Species;
SELECT COUNT(*) FROM Site;
SELECT COUNT(*) FROM Species;
SELECT 99 * 16;

-- *any* condition can be expression, we have complete freedom here

-- But when there is a foreign key relation, then
-- what happens?
-- the result is the same as the table with the foreign key but augmented with additional columns
SELECT * FROM Bird_nests BN JOIN Species S
    ON BN.Species = S.Code
    LIMIT 5;

SELECT COUNT(*) FROM Bird_nests BN JOIN Species S
    ON BN.Species = S.Code;


-- Table aliases
-- Sometimes if column names are ambigious where they're coming from,  we need to qualify them
SELECT * FROM Bird_nests JOIN Species
    ON Bird_nests.Species = Species.Code;

-- same, using a table alias
SELECT COUNT(*) FROM Bird_nests AS BN JOIN Species AS S
    ON BN.Species = S.Code;
-- even more compact, leave out "AS"

