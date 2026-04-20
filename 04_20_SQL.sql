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


-- REVIEW AND CONTINUING DISCUSSION OF JOINS
-- by default joins are inner
-- What is a join? Conceptually, the data base performs a "Cartesian product" of the tables, then matches up rows based on some kind of join condition
-- in some databases to do a cartesian product you would just do a JOIN without a condition, e.g.,
-- cartesian product is every product of table A is linked to every product on table B
SELECT * FROM A JOIN B;
-- **BUT** in DuckDB, you have to say
SELECT * FROM A CROSS JOIN B;
SELECT * FROM A;
SELECT * FROM B;

-- heres what the Cartesian product looks like:
SELECT * FROM A CROSS JOIN B;

--Let's add a join condition which can be *any* expression!
SELECT * FROM A JOIN B ON acol1< bcol1;

--This is whats referred to as an INNER JOIN
SELECT * FROM A INNER JOIN B ON acol1 <bcol1;

-- outer join: we're adding rows from one table that never got matched
SELECT * FROM A RIGHT JOIN B ON acol1 < bcol1;

SELECT * FROM A LEFT JOIN B ON acol1 < bcol1;

-- just for completeness: can do a full outer join
SELECT * FROM A FULL OUTER JOIN B ON acol1 < bcol1;

-- now joining on a foreign key relationship is way more common 
.schema

SELECT * FROM House;
SELECT * FROM Student;

-- typical thing to do 
SELECT * FROM Student S JOIN House H ON S.House_ID = H.House_ID;

-- without the aliases:
SELECT * FROM Student JOIN House ON Student.House_ID = House.House_ID;

-- one nice benefit of joining on a column that has the same nae is you can use the USING clause
SELECT * FROM Student JOIN House USING (House_ID);

-- BIRD DATABASE
SELECT COUNT (*) FROM Bird_eggs;

-- for better viewing
.mode line 

SELECT * FROM Bird_eggs LIMIT 1;
SELECT * FROM Bird_eggs JOIN Bird_nests USING (Nest_ID) LIMIT 1;
SELECT COUNT(*) FROM Bird_eggs JOIN Bird_nests USING (Nest_ID);
.mode duckbox

-- ORDERING SHOULD BE DONE LAST TO PRESERVE IT
-- ordering is lost doing a join. dont say this 
SELECT * FROM
    (SELECT * FROM Bird_eggs ORDER BY Width)
    JOIN Bird_nests
    USING (Nest_ID);

-- gotcha with DuckDB..

SELECT Nest_ID, Count(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

-- This doesn't work 
SELECT Nest_ID, Species, Count(*)
    FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
    GROUP BY Nest_ID;

-- workaround
SELECT Nest_ID, ANY_VALUE(Species), COUNT(*)
    FROM Bird_eggs JOIN Bird_nests USING (Nest_ID)
    GROUP BY Nest_ID;

SELECT Nest_ID, Species, COUNT(*)
    FROM Bird_eggs JOIN Bird_nests USING (Nest_ID)
    GROUP BY Nest_ID, Species;


-- any value literally returns any value
SELECT Nest_ID, ANY_VALUE(Width)
    FROM Bird_eggs
    GROUP BY Nest_ID;