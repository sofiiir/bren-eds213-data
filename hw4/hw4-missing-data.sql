-- which sites have no egg data
-- first view the data
SELECT * FROM Site;
SELECT * FROM Bird_eggs;

-- with a not in clause
SELECT Code 
    FROM Site
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs)
    ORDER BY Code;

-- with an outer join
SELECT Code
    FROM Site LEFT JOIN Bird_eggs
    ON Code = Site
    WHERE Site IS NULL
    ORDER BY Code;

