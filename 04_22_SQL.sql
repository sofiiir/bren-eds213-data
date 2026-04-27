-- view the toy.duckdb table 
SELECT (*) FROM A;
SELECT (*) FROM B;

-- CROSS JOIN REVIEW
-- cross joins are the most expensve thing that can be done in a relational database so any filters should be done before
-- gives all of the combinations possible between table A and B
-- we get the number of columns from each A + B
-- we get the number of rows from each A * B
-- this is the Cartesian product
-- usse when there is no key between the two tables
SELECT * FROM A CROSS JOIN B;

-- SELECT always selects columns from after the FROM 
-- starts with whats in the parentheses
SELECT acol1, acol2 FROM (SELECT * FROM A CROSS JOIN B);

-- DIFFERENCES BETWEEN COUNT(*) == number of rows & COUNT(column) == Non-NULL value counts
-- less desirable to use GROUP BY
SELECT acol1, acol2, COUNT (*) AS Count
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1, acol2;

-- preferred to use ANY_VALUE()
SELECT acol1, ANY_VALUE(acol2), COUNT (*) AS Count
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1;

-- count of a row ignores NULLs
SELECT acol1, ANY_VALUE(acol2), COUNT (bcol3) 
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1;

-- USING A CONDITION
-- just do the join when acol 1 is smaller than bcol1
SELECT * FROM A JOIN B ON acol1 < bcol1;

-- INNER or OUTER JOINS
SELECT * FROM Student;
SELECT * FROM House;

-- INNER JOIN
-- when you do joins on keys it always does the inner join by default
SELECT * 
    FROM Student AS S JOIN House AS H 
    ON S.House_ID = H.House_ID;

-- if key being joined is the same we can use USING() (which requires the same column name)
SELECT * FROM Student JOIN House USING (House_ID);

-- select only names from the two dataframes
SELECT H.Name, S.Name 
    FROM Student AS S JOIN House AS H 
    USING (House_ID);

-- OUTER JOINS
SELECT * FROM Student FULL JOIN House USING (House_ID);

SELECT * FROM Student LEFT JOIN House USING (House_ID);

SELECT * FROM Student RIGHT JOIN House USING (House_ID);

SELECT * FROM Student  JOIN House USING (House_ID);

-- you can still run a CROSS JOIN even if you have a key
SELECT * FROM Student CROSS JOIN House;
