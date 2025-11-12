    -- 3. Product & Order Insights
--         3.1. What are the top 10 most sold products (by quantity)?

			    SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) AS TotalQuantitySold
                FROM products P
                JOIN orderdetails OD ON OD.ProductID = P.ProductID
                GROUP BY P.ProductID, P.ProductName
                ORDER BY TotalQuantitySold DESC
                LIMIT 10;
                
--         3.2. What are the top 10 most sold products (by revenue)?
                
                SELECT P.ProductID, P.ProductName, SUM(OD.Quantity*P.Price) AS Total_revenue
                FROM products P
                JOIN orderdetails OD ON OD.ProductID = P.ProductID
                GROUP BY P.ProductID, P.ProductName
                ORDER BY Total_revenue DESC
                LIMIT 10;
                
--         3.3. Which products have the highest return rate?
                
                SELECT P.ProductName,ROUND((SUM(CASE 
							WHEN O.IsReturned = 1 THEN OD.Quantity ELSE 0 END) * 100.0)/SUM(OD.Quantity),2) AS ReturnRatePercent
                FROM OrderDetails OD
				JOIN Products P ON OD.ProductID = P.ProductID
                JOIN Orders O ON O.OrderID = OD.OrderID
                GROUP BY P.ProductName
                ORDER BY ReturnRatePercent DESC;

--         3.4. Return Rate by Category

                SELECT P.Category,ROUND((SUM(CASE 
                               WHEN O.IsReturned = 1 THEN OD.Quantity ELSE 0 END) * 100.0)/ SUM(OD.Quantity),2) AS ReturnRatePercent
                FROM OrderDetails OD
                JOIN Products P ON OD.ProductID = P.ProductID
                JOIN Orders O ON O.OrderID = OD.OrderID
				GROUP BY P.Category
				ORDER BY ReturnRatePercent DESC;

--         3.5. What is the average price of products per region?
                
                SELECT P.ProductID, P.ProductName, AVG(P.Price) AS AvgPrice, R.RegionID, R.RegionName
                FROM products P
                JOIN orderdetails OD ON P.ProductID = OD.ProductID
                JOIN orders O ON OD.OrderID = O.OrderID
                JOIN customers C ON O.CustomerID = C.CustomerID
                JOIN regions R ON C.RegionID = R.RegionID
                GROUP BY P.ProductID, P.ProductName, R.RegionID, R.RegionName
                ORDER BY R.RegionName;
                
--         3.6. What is the sales trend for each product category?

				SELECT P.Category, SUM(OD.Quantity*P.Price) AS Total_sales
                FROM products P
                JOIN orderdetails OD ON P.ProductID = OD.ProductID
                GROUP BY P.Category
                ORDER BY P.Category, Total_sales;