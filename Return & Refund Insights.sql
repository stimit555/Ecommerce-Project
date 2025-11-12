--    6. Return & Refund Insights
--      6.1. What is the overall return rate by product category?
   
             SELECT P.Category,COUNT(OD.OrderID) AS TotalOrders,
			 SUM(CASE 
                     WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) AS ReturnedOrders,ROUND(100.0 * 
                     SUM(CASE 
                         WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) / COUNT(O.OrderID),2) AS ReturnRatePercent
			 FROM Orders O
             JOIN OrderDetails OD ON O.OrderID = OD.OrderID
			 JOIN Products P ON OD.ProductID = P.ProductID
             GROUP BY P.Category
             ORDER BY ReturnRatePercent DESC;

--      6.2. What is the overall return rate by region?

             SELECT R.RegionName,COUNT(OD.OrderID) AS TotalOrders,
			 SUM(CASE 
                     WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) AS ReturnedOrders,ROUND(100.0 * 
                     SUM(CASE 
                         WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) / COUNT(O.OrderID),2) AS ReturnRatePercent
			 FROM Orders O
             JOIN OrderDetails OD ON O.OrderID = OD.OrderID
             JOIN Customers C ON O.CustomerID = C.CustomerID
			 JOIN Regions R ON C.RegionID = R.RegionID
             GROUP BY R.RegionName
             ORDER BY ReturnRatePercent DESC;
             
--      6.3. Which customers are making frequent returns?
             
             SELECT C.CustomerID, C.CustomerName,COUNT(DISTINCT O.OrderID) AS TotalOrders,
             SUM(CASE 
                     WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) AS TotalReturns,ROUND(
					100.0 * SUM(CASE 
                                     WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) / COUNT(O.OrderID),2) AS ReturnRatePercent
			 FROM Customers C
             JOIN Orders O ON C.CustomerID = O.CustomerID
             JOIN OrderDetails OD ON O.OrderID = OD.OrderID
             GROUP BY C.CustomerID, C.CustomerName
			 HAVING SUM(CASE 
                            WHEN O.IsReturned = 1 THEN 1 ELSE 0 END) > 0  -- Only customers with returns
             ORDER BY TotalReturns DESC;