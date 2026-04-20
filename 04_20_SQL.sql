-- First review item: tri-value logic
--expressions can have a value (if Boolean, TRUE or FALSE), but they can also be NULL
-- In selecting rows, NULL doesn't cut it, NULL doesn't count as TRUE

SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge < 7 OR floatAge >= 7;


SELECT COUNT(*) FROM Bird_nests
    WHERE floatAge IS NULL;

-- Review item: relational algebra
-- Everything is a table! Every operation returns a table!
-- Even simple COUNT (*) RETURNS  a table
SELECT COUNT(*) FROM Bird_nests;

-- We looked at one example of nesting SELECTS
-- select as species not in the bird nests
SELECT Scientific_name
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);


-- count the number of species not in bird nest
SELECT COUNT(*) FROM
    (SELECT Scientific_name
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests));


-- Let's pretend that SQL didn't have a HAVING clause. Could we somehow get the same functionality?

SELECT Location, MAX(Area) AS Max_area
    FROM Site 
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Max_area > 200; -- the having clause is applying to the groups 

SELECT * FROM
        (SELECT Location, MAX(Area) AS Max_area
        FROM Site 
        WHERE Location LIKE '%Canada'
        GROUP BY Location)    
    WHERE Max_area > 200;