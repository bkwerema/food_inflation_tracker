/* Validating the Data

To show all the locations  and their item count 
This is just to make sure that all states have the same data and 
now that we know 'Newfoundland and Labrador' does not have the same data,
we will eliminate it from this analysis to prevent inaccuracy
*/
select fd.Location ,
count(fd.Products) as product_count
from dbo.Food_Prices as fd 
group by fd.Location;


/*
Find the Average Prices for Each Food Item By Location(Province) - Table 1
*/
SELECT 
fd.Location,
fd.Products Food_Item ,
ROUND(AVG(Price), 2) as average_price
FROM dbo.Food_Prices as fd
WHERE (NOT fd.Location =  'Newfoundland and Labrador')
GROUP BY fd.Location , fd.Products
ORDER BY 1 , 2 ;





/* Average Price For Food Items Sold By Kilogram
It's noted that Beef is the most expensive item across the board based on foods sold by kilogram
*/
SELECT 
fd.Products Food_Item ,
AVG(Price) as price
FROM dbo.Food_Prices as fd
WHERE fd.Products LIKE '% per kilogram%'
AND (NOT fd.Location =  'Newfoundland and Labrador')
GROUP BY fd.Products
ORDER BY 2 DESC , 1 ;





/* Let's dig deeper to investigate the price of these food items
and see which one has steadily increased over the past 5 years  - Table 2 */
SELECT 
year(fd.Date_Formatted) as Year,
fd.Location Province,
fd.Products Food_Item ,
ROUND(AVG(Price),2) as price
FROM dbo.Food_Prices as fd
WHERE fd.Products LIKE '% per kilogram%'
AND  (NOT fd.Location =  'Newfoundland and Labrador')
GROUP BY year(fd.Date_Formatted),fd.Location , fd.Products
ORDER BY 2 DESC , 1 ;





/*Find the Most Expensive Meat item Across All Provinces Over the Past Years
Using Percentage 
Well these numbers make sense considering how much i am shocked at the price of Steak 
everytime i walk into a store whether its walmart or superstore.
Beef Rib Cuts Are the most expensive meat item - Table 3
*/
SELECT 
fd.Location,
fd.Products Product,
Y2018_Avg_Price ,
round(100 - (Y2018_Avg_Price/Y2019_Avg_Price  * 100 ), 2)  as '2018-2019 % Change' ,
Y2019_Avg_Price ,
round(100 - (Y2019_Avg_Price/Y2020_Avg_Price  * 100 ), 2)  as '2019-2020 % Change' ,
Y2020_Avg_Price ,
round(100- (Y2020_Avg_Price/Y2021_Avg_Price  * 100 ), 2)  as '2020-2021 % Change' ,
Y2021_Avg_Price ,
round(100 - (Y2021_Avg_Price/Y2022_Avg_Price  * 100 ), 2)  as '2021-2022 % Change' ,
Y2022_Avg_Price , 
round(100 - (Y2022_Avg_Price/Y2023_Avg_Price  * 100 ), 2)  as '2022-2023 % Change' ,
Y2023_Avg_Price ,
round(100 - (Y2018_Avg_Price/Y2023_Avg_Price  * 100 ), 2)  as 'Overall % Change' 
FROM dbo.Food_Prices as fd
LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2023_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE fd.Products LIKE '%beef%' 
AND year(fd.Date_Formatted) = '2023'
GROUP BY fd.Location , fd.Products
)as y2023_join 
on y2023_join.Product = fd.Products 
and y2023_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2022_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE fd.Products LIKE '%beef%' 
AND year(fd.Date_Formatted) = '2022'
GROUP BY fd.Location , fd.Products
)as y2022_join
on y2022_join.Product = fd.Products 
and y2022_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2021_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE fd.Products LIKE '%beef%' 
AND year(fd.Date_Formatted) = '2021'
GROUP BY fd.Location , fd.Products
)as y2021_join
on y2021_join.Product = fd.Products 
and y2021_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2020_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE fd.Products LIKE '%beef%' 
AND year(fd.Date_Formatted) = '2020'
GROUP BY fd.Location , fd.Products
)as y2020_join
on y2020_join.Product = fd.Products 
and y2020_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2019_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE fd.Products LIKE '%beef%' 
AND year(fd.Date_Formatted) = '2019'
GROUP BY fd.Location , fd.Products
)as y2019_join
on y2019_join.Product = fd.Products 
and y2019_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2018_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE fd.Products LIKE '%beef%' 
AND year(fd.Date_Formatted) = '2018'
GROUP BY fd.Location , fd.Products 
)as y2018_join
on y2018_join.Product = fd.Products 
and y2018_join.Location = fd.Location 

WHERE fd.Products LIKE '%beef%' 
AND  (NOT fd.Location =  'Newfoundland and Labrador')
GROUP BY fd.Location ,fd.Products , 
                    Y2018_Avg_Price ,
                    Y2019_Avg_Price ,
                    Y2020_Avg_Price ,
                    Y2021_Avg_Price ,
                    Y2022_Avg_Price , 
                    Y2023_Avg_Price 
ORDER BY 2 , 14 DESC;







/* What food item's price has increased the slowest and in what state  
Pork Shoulder Cuts in Quebec 
On studying the data a little bit more, i am noticing that Quebec maybe 
one of the cheapest territories to live in atleast based on the prices of their food.

If you'll notice, Quebec appears quite often in this top 20 list of items whose food
 prices have not climbed over the past 5 years.

 Other safe states could include: Manitoba

 Ontario appears in this list when it comes to items sold per kilogram but this is probably 
 because of the urbanity of the state. Most people are vegeterians.

 But if we unfilter this list and allow it to accomodate all items, 
 you'll notice that Ontario quickly disappears - which makes sense - it is after all one of 
 the most expensive states to live in
 Same thing with BC - Table 4
*/
SELECT TOP 20
fd.Location,
fd.Products Product,
Y2018_Avg_Price ,
round(100 - (Y2018_Avg_Price/Y2019_Avg_Price  * 100 ), 2)  as '2018-2019 % Change' ,
Y2019_Avg_Price ,
round(100 - (Y2019_Avg_Price/Y2020_Avg_Price  * 100 ), 2)  as '2019-2020 % Change' ,
Y2020_Avg_Price ,
round(100- (Y2020_Avg_Price/Y2021_Avg_Price  * 100 ), 2)  as '2020-2021 % Change' ,
Y2021_Avg_Price ,
round(100 - (Y2021_Avg_Price/Y2022_Avg_Price  * 100 ), 2)  as '2021-2022 % Change' ,
Y2022_Avg_Price , 
round(100 - (Y2022_Avg_Price/Y2023_Avg_Price  * 100 ), 2)  as '2022-2023 % Change' ,
Y2023_Avg_Price ,
round(100 - (Y2018_Avg_Price/Y2023_Avg_Price  * 100 ), 2)  as 'Overall % Change' 
FROM dbo.Food_Prices as fd
LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2023_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE  year(fd.Date_Formatted) = '2023'
GROUP BY fd.Location , fd.Products
)as y2023_join 
on y2023_join.Product = fd.Products 
and y2023_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2022_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE 
 year(fd.Date_Formatted) = '2022'
GROUP BY fd.Location , fd.Products
)as y2022_join
on y2022_join.Product = fd.Products 
and y2022_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2021_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE 
 year(fd.Date_Formatted) = '2021'
GROUP BY fd.Location , fd.Products
)as y2021_join
on y2021_join.Product = fd.Products 
and y2021_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2020_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE 
 year(fd.Date_Formatted) = '2020'
GROUP BY fd.Location , fd.Products
)as y2020_join
on y2020_join.Product = fd.Products 
and y2020_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2019_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE year(fd.Date_Formatted) = '2019'
GROUP BY fd.Location , fd.Products
)as y2019_join
on y2019_join.Product = fd.Products 
and y2019_join.Location = fd.Location

LEFT JOIN 
(
SELECT 
fd.Location,
fd.Products Product,
ROUND(AVG(Price), 2) AS Y2018_Avg_Price 
FROM dbo.Food_Prices as fd
WHERE year(fd.Date_Formatted) = '2018'
GROUP BY fd.Location , fd.Products 
)as y2018_join
on y2018_join.Product = fd.Products 
and y2018_join.Location = fd.Location 
WHERE 
/*fd.Products LIKE '% per kilogram%' */
 (NOT fd.Location =  'Newfoundland and Labrador')
GROUP BY fd.Location ,fd.Products , 
                    Y2018_Avg_Price ,
                    Y2019_Avg_Price ,
                    Y2020_Avg_Price ,
                    Y2021_Avg_Price ,
                    Y2022_Avg_Price , 
                    Y2023_Avg_Price 
ORDER BY 14 ASC ;


/* Sample of the Data for analysing using Python */
SELECT 
fd.Date_Formatted AS 'Date',
fd.Location Province,
fd.Products Food_Item ,
ROUND(AVG(Price),2) as price
FROM dbo.Food_Prices as fd
WHERE 
(NOT fd.Location =  'Newfoundland and Labrador')
AND (
fd.Date_Formatted LIKE '%2018%' OR 
fd.Date_Formatted LIKE '%2020%' OR 
fd.Date_Formatted LIKE '%2022%'
)
GROUP BY fd.Date_Formatted , fd.Location , fd.Products
ORDER BY 1 , 2 , 3 ;



/* Next - Showcasing this data in Tableau 
*/






