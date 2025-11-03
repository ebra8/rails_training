-- Revising Aggregations - The Sum Function
SELECT SUM(POPULATION)
FROM CITY
WHERE DISTRICT = 'California';


-- Average Population
SELECT AVG( FLOOR( POPULATION ) )
FROM CITY;


-- African Cities
SELECT CITY.name
FROM CITY
JOIN COUNTRY
    ON CITY.CountryCode  = COUNTRY.Code
WHERE COUNTRY.CONTINENT = "Africa";


-- Average Population of Each Continent
SELECT COUNTRY.Continent, 
       FLOOR( AVG( CITY.Population ) )
FROM COUNTRY
JOIN CITY
    ON COUNTRY.CODE = CITY.CountryCode
GROUP BY Continent;


-- Placements
WITH student AS (
    SELECT Students.ID,
            Students.Name,
            Packages.Salary,
            Friends.Friend_ID
    FROM Students
    JOIN Packages
        ON Students.ID = Packages.ID
    JOIN Friends
        ON Friends.ID = Students.ID
)
SELECT student.name
FROM student
JOIN student AS friend ON friend.ID = student.Friend_ID
WHERE friend.Salary > student.Salary
ORDER BY friend.Salary;
