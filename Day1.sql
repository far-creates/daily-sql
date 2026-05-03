-- DAY 1

USE Northwind;

-- Q1
/* Show the top 5 products by total revenue (unit price × quantity ordered). 
Include the product name and total revenue, sorted highest to lowest. */


SELECT TOP 5 WITH TIES P.ProductID, SUM(OD.UnitPrice * OD.Quantity) TotalRevenue
FROM Products P, [Order Details] OD
WHERE P.ProductID = OD.ProductID
GROUP BY P.ProductID
ORDER BY TotalRevenue DESC

SELECT TOP 5 WITH TIES P.ProductID, P.ProductName, SUM(OD.UnitPrice * OD.Quantity) TotalRevenue
FROM Products P
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductID, P.ProductName
ORDER BY TotalRevenue DESC

SELECT OrderAgg.ProductID, P.ProductName, OrderAgg.TotalRevenue
FROM (  SELECT TOP 5 WITH TIES P.ProductID, SUM(OD.UnitPrice * OD.Quantity) TotalRevenue
		FROM Products P
		JOIN [Order Details] OD ON P.ProductID = OD.ProductID
		GROUP BY P.ProductID
		ORDER BY TotalRevenue DESC) OrderAgg
JOIN Products P ON OrderAgg.ProductID = P.ProductID

-- Q2
/* Find all customers who have placed more than 10 orders. Show the CustomerID, CompanyName, 
and their total number of orders, sorted by most orders first. */

SELECT C.CustomerID, C.CompanyName, COUNT (O.OrderID) TotalOrders
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerID, C.CompanyName 
HAVING COUNT (O.OrderID) > = 10
ORDER BY TotalOrders DESC

-- Q3
/* Show all orders placed in 1997, with the customer's company name and the employee's full name who handled the order. 
Sort by order date. */

SELECT O.OrderID, C.CompanyName OrderedBy, E.FirstName + N' ' + E.LastName HandledBy
FROM Orders O 
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Employees E ON O.EmployeeID = E.EmployeeID
WHERE Year(O.OrderDate) = 1997
ORDER BY O.OrderDate ASC

-- Q4
/* Find all products that have a unit price higher than the average unit price of all products. 
Show product name and unit price.*/ 

SELECT P.ProductID, P.ProductName, P.UnitPrice
FROM Products P
WHERE P.UnitPrice > (SELECT AVG(UnitPrice) FROM Products)
ORDER BY UnitPrice DESC

-- Q5
/* For each category, show the category name, number of products in it, and the average unit price. 
But only show categories where the average unit price is higher than 20. Sort by average price descending.*/

SELECT C.CategoryID, C.CategoryName, CatSummary.AvgPrice, CatSummary.TotalUnits
FROM (  SELECT CategoryID, SUM (UnitsInStock) TotalUnits, ROUND( AVG (UnitPrice),2) AvgPrice
		FROM Products 
		GROUP BY CategoryID) CatSummary
JOIN Categories C ON CatSummary.CategoryID = C.CategoryID
WHERE CatSummary.AvgPrice > 20
ORDER BY CatSummary.AvgPrice DESC