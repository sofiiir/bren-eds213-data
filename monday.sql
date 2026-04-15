# to verify that we have the "right" database open, look what tables are in the database: .table

# to see that the DuckDB-specific commands, do this: .help OR .help mode

# to exit do : .exit OR ctrl - D

# in SQL, comments are delimities with --

--.table -- lists tables
-- .schema -- lists the whole schema
.schema

-- Getting help on SQL: look at the "railroad" diagrams in SQLite
-- check out https:://sqlite.org/lang.html

-- Our first query
-- The * means all columns; all rows are implied because we didn't specify a WHERE clase
SELECT * FROM Species;

-- A couple gotchas
-- 1. Don't forget the closing semicolon, DuckDB will wait for it forever
-- 2. Watch for missing closing quotes


-- to see just a few rows:
SELECT * FROM Species LIMIT 5;

-- can also "page" through the rows
SELECT * FROM Species LIMIT 5 OFFSET 5;

-- of course we can select which columns we want
SELECT Code, Scientific_name FROM Species;

-- another handy query to explore data
SELECT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests;

-- can also get distinct pairs or tuples that occur
SELECT DISTINCT Species, Observer FROM Bird_nests;

-- can ask that resilts be ordered
SELECT Scientific_name FROM Species;
SELECT Scientific_name FROM Species ORDER BY Scientific_name;

-- the default ordering (which is undefined) can be subtle
SELECT DISTINCT Species FROM Bird_nests;
SELECT DISTINCT Species FROM Bird_nests LIMIT 3;

-- let's try again, but ask that the results be ordered
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species;
SELECT DISTINCT Species FROM Bird_nests ORDER BY Species LIMIT 3;

-- in-class challenge:
-- select distinct locations from the site table; are they in order? if not order them.
SELECT DISTINCT Location FROM Site ORDER BY Location; 