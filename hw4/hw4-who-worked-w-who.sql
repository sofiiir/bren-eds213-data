
-- before manipulating the 
SELECT * FROM Camp_assignment;
 
 -- match all people that worked at the same site
-- this doesnt account for overlapping time 
SELECT * FROM Camp_assignment A JOIN Camp_assignment B
    On A.Site = B.Site;

-- match people working at the same site and the same time
SELECT * FROM Camp_assignment A JOIN Camp_assignment B
    On A.Site = B.Site 
    AND A.Start <= B.End
    AND B.Start <= A.End;

-- investigate the match of site and time
-- this shows people working with themselves
SELECT * FROM Camp_assignment A JOIN Camp_assignment B
    On A.Site = B.Site 
    AND A.Start <= B.End
    AND B.Start <= A.End
    WHERE A.Site = 'lkri';

-- final output for people that worked together at lkri
SELECT A.Site, 
        A.Observer AS Observer_1, 
        B.Observer AS Observer_2
    FROM Camp_assignment A JOIN Camp_assignment B
    On A.Site = B.Site 
    AND A.Start <= B.End
    AND B.Start <= A.End 
    AND A.Observer > B.Observer
    WHERE A.Site = 'lkri';

-- BONUS 
-- view the personnel table
SELECT * FROM Personnel; 

-- whose working with who at lkri with full names
SELECT A.Site, 
        p1.Name, 
        p2.Name
    FROM Camp_assignment A 
    JOIN Camp_assignment B
    On A.Site = B.Site 
    AND B.Start <= A.End
    AND A.Start <= B.End 
    AND A.Observer > B.Observer
    JOIN Personnel AS p1 ON p1.abbreviation = B.Observer
    JOIN Personnel AS p2 ON p2.abbreviation = A.Observer
    WHERE A.Site = 'lkri'; -- select site of interest last

