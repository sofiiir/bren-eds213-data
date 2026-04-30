-- which sites have no egg data
-- with a not in clause
SELECT Code 
    FROM Site
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs)
    ORDER BY Code;

-- with an outer join
SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    ON Species = Code
    WHERE Species IS NULL;