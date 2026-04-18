-- PART 1
-- we want to know which site has the largest area BUT this gives an error
SELECT Site_name, MAX(Area) FROM Site;
-- we would need to group by to get the max based on site_name



-- this gives us max area for the whole dataframe
SELECT MAX(Area) FROM Site;

SELECT Site_name, AVG(Area) FROM Site;
SELECT Site_name, COUNT(*) FROM Site;
SELECT Site_name, SUM(Area) FROM Site;

-- PART 2
-- query for the site_name with the largest area  
SELECT Site_name, MAX(Area) 
    FROM Site
    GROUP BY Site_name
    ORDER BY Max(Area) DESC
    LIMIT 1;

-- PART 3
-- use a nested query to first create a query that finds the max area
-- then create a query that selects the site name and area of the site whose area equals the maximum
SELECT Site_name, Area 
    FROM Site
    WHERE AREA = (SELECT MAX(AREA)
                  FROM Site);