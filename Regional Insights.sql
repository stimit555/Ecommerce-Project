--    5. Regional Insights
--      5.1. Which regions have the highest order volume and which have the lowest?

			 -- Highest order volume
             
             SELECT R.RegionName,R.Country,COUNT(O.OrderID) AS TotalOrders
			 FROM Orders O
             JOIN Customers C ON O.CustomerID = C.CustomerID
			 JOIN Regions R ON C.RegionID = R.RegionID
             GROUP BY R.RegionName, R.Country
             ORDER BY TotalOrders DESC;
			
             -- Lowest order volume
             
             SELECT R.RegionName,R.Country,COUNT(O.OrderID) AS TotalOrders
			 FROM Orders O
             JOIN Customers C ON O.CustomerID = C.CustomerID
			 JOIN Regions R ON C.RegionID = R.RegionID
             GROUP BY R.RegionName, R.Country
             ORDER BY TotalOrders;

--      5.2. What is the revenue per region and how does it compare across different regions?

             SELECT R.RegionName,R.Country,SUM(OD.Quantity*P.Price) AS TotalRevenue
             FROM Orders O
             JOIN OrderDetails OD ON O.OrderID = OD.OrderID
             JOIN Products P ON OD.ProductID = P.ProductID
             JOIN Customers C ON O.CustomerID = C.CustomerID
			 JOIN Regions R ON C.RegionID = R.RegionID
             GROUP BY R.RegionName, R.Country
             ORDER BY TotalRevenue DESC;