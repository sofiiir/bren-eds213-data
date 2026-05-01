-- views review
CREATE VIEW Nest_view AS 
    SELECT Book_page, Year, Site, Nest_ID, Scientific_name, Observer
    FROM Bird_nests JOIN Species
    ON Species = Code;

SELECT * FROM Nest_view LIMIT 1;

-- for comparison
SELECT * FROM Bird_nests LIMIT 1;

-- let's use our view for a more substantial purpose: counting eggs,
-- but we'd like to see the nest ID and the scientific name for each nest

SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (NEST_ID)
    GROUP BY NEST_ID;

-- View compared to temp tables:
-- Temp table is more like a variable in a programming language
-- As the name suggests the temp table only lasts for the session


-- Another option: Use a with clause!
WITH x AS(
SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (NEST_ID)
    GROUP BY NEST_ID
) SELECT Scientific_name, AVG(Num_eggs) AS Avg_num_eggs FROM x
  GROUP BY Scientific_name;

-- The variable("x" in this case) only lasts for the statements; its really a kind of abbreviation

-- SET OBSERVATIONS
-- recall that tables are **sets** of rows, not ordered lists
-- we can do set observations on tables
-- union, intersect, except (set differences)
-- one note: these are set observations so duplicates are eliminated in UNIONS
-- but if you do want to preserve all rows, UNION ALL

-- we want a table of bird nests and egg counts , but we also want entries
-- for nests that have no eggs (they should have a count of 0)

SELECT Nest_ID, COUNT(Egg_num) AS Num_eggs
    FROM Bird_nests LEFT JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID;

-- let's try solving the same problem but using UNION
SELECT Nest_ID, COUNT(*) AS Num_eggs
    FROM Bird_eggs
    GROUP BY Nest_ID

    UNION

    SELECT Nest_ID, 0 AS Num_eggs
        FROM Bird_eggs
        WHERE Nest_ID NOT IN (SELECT DISTINCT Nest_ID FROM Bird_eggs);


-- Join conditions on a foreign key, two ways
-- ... ON Species = Code (if unambiguous we don't need the prefixing dataframe)
-- ... USING (Nest_ID) (works if both tables have the same name for the key)

-- Note on UNIONS: SQL will UNION any two tables that have the same 
-- number of columns and compatible data types


-- Example of when you might want to use ECXCEPT

-- Question: which species do we *not* have data for? 
-- Three ways: 

-- WAY 1: 
SELECT Code 
    FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);

-- WAY 2:
SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Species IS NULL;

-- WAY 3: 
SELECT Code 
    FROM Species
    EXCEPT 
    SELECT DISTINCT Species FROM Bird_nests;

-- Enough with SELECT! Data management statements
-- INSERT STATEMENTS
SELECT * FROM Personnel;
INSERT INTO Personnel VALUES ('gjanee', 'Greg Janee');
SELECT * FROM Personnel;

-- good practice for safer code: name the columns
INSERT INTO Personnel (Abbreviation, Name) VALUES ('jbrun', 'Julien Brun');

-- when you insert a row in a table your dont necessarily need to specify
-- all the values ; anthing not specified will either be filled with NULL or a default
-- another reason to spell out the column names


-- Databases typically have some kind of load function to load data in bulk

-- updates and deletes
SELECT * FROM Bird_nests LIMIT 10;
UPDATE Bird_nests SET floatAge = 6.5, ageMethod = 'float'
    WHERE Nest_ID = '14HPE1';

SELECT * FROM Bird_nests LIMIT 10;

-- Delete is very similar
-- DELETE FROM Bird_nests WHERE ...; 

-- UPDATE and DELETE are incredibly dangerous
-- if no WHERE clause UPDATE and DELETE operates on all rows in the table
-- UPDATE Bird_nests SET floatAge = NULL;
-- SELECT * FROM Bird_nests;

-- To fix the issue if working on a git file
.exit
git restore database.duckdb
duckdb database.duckdb

-- What's a strategy to not make this terrible mistake? 
-- one idea: 
-- First do a select to confirm the rows you want to operate on, then edit the statement to do an update
SELECT * FROM Bird_nests WHERE Nest_ID == '98nome7';

-- Another idea
-- Use a fake table name, then change to the real name
UPDATE Bird_nests XXX SET ... WHERE ...;

