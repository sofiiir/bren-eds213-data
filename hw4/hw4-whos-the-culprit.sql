-- incorrect float method investigation 

-- view the bird_nests dataframe
SELECT * FROM Bird_nests;

-- look at the count of nests counted by float method
SELECT  Site,
        Observer, 
        ageMethod,
        COUNT(*) 
    FROM Bird_nests 
    WHERE ageMethod = 'float'
    GROUP BY Observer, ageMethod, Site; 

-- query for the person who floated 36 nests in Nome
-- from the query above we know that 36 float is unique to all sites but make th where clause specific to avoid ambiguity
SELECT Name, 
    Num_floated_nests
        FROM (SELECT  Site,
        Observer, 
        ageMethod,
        COUNT(*) AS Num_floated_nests
    FROM Bird_nests 
    GROUP BY Observer, ageMethod, Site)
    JOIN Personnel ON abbreviation = Observer
    WHERE ageMethod = 'float' AND Num_floated_nests = 36 AND Site = 'nome';