USE Apparel;

-- Convert OrderDate string into a Date format so I can Separate out an OrderYear
CREATE OR REPLACE VIEW sales_cleaned AS
SELECT
  OrderID,
  ProductID,
  Product,
  CustomerID,
  EmployeeID,
  OrderDate,
  STR_TO_DATE(OrderDate, '%d -%b - %y') AS ParsedDate,
  YEAR(STR_TO_DATE(OrderDate, '%d -%b - %y')) AS OrderYear,
  Sales,
  Cost,
  Quantity
FROM sales_data;

-- Number of Orders per Year
Select count(Distinct OrderID) as NumOrders, OrderYear
from sales_cleaned
GROUP bY OrderYear
Order by OrderYear;

-- Create A View That Shows The Quanity of Each Individual Product Sold Every Year
CREATE OR REPLACE VIEW AmountOfProductSoldEachYear AS
Select Product, OrderYear, SUM(Quantity) as TotalSold
FROM sales_cleaned
Group by Product,OrderYear;

-- Find the Most Sold Product per Year
SELECT a1.Product,a1.OrderYear,a1.TotalSold as MaxSold
FROM AmountOfProductSoldEachYear a1
JOIN AmountOfProductSoldEachYear a2
	On  a1.OrderYear = a2.OrderYear 
Group By a1.Product,a1.OrderYear,a1.TotalSold
HAVING a1.TotalSold = Max(a2.TotalSold) 
Order By a1.OrderYear;

-- Total number of items sold per year
select OrderYear, sum(TotalSold) as YearlyTotalItemsSold
from amountofProductsoldeachyear
Group By OrderYear
order by OrderYear;

-- Find How many different items were sold each year, See if business is adding on more product
select OrderYear, count(distinct Product) as NumOfProducts
from amountofProductsoldeachyear
Group By OrderYear
order by OrderYear;


-- Number of Countries that have bought Apparel
Select count(distinct CustomerCountry) as NumCountries
from customer_data
ORDER BY NumCountries;

-- Join customer_data with sales_cleaned to look a country sales
CREATE OR REPLACE VIEW country_sales AS
SELECT s.OrderID,s.ProductID,s.Product,s.CustomerID,s.EmployeeID,s.OrderDate,s.ParsedDate,s.OrderYear,s.Sales,s.Cost,Quantity,c.CustomerCountry
FROM sales_cleaned  s
JOIN customer_data c
	On s.CustomerID = c.CustomerID;
 
-- Number of Orders from each country by year
select Customercountry,OrderYear, Count(Distinct OrderID) as NumOrders
from country_sales
Group by CustomerCountry,OrderYear
Order by OrderYear;

-- Number of countries sold to each year
select OrderYear, Count(Distinct CustomerCountry) as NumOfCountries
from country_sales
Group by OrderYear
Order by OrderYear;


