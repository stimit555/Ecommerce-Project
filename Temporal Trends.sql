    -- 4. Temporal Trends
--         4.1. What are the monthly sales trends over the past year?
  
				SELECT DATE_FORMAT(O.OrderDate, '%Y-%m') AS Month, SUM(OD.Quantity*P.Price) AS Total_sales
                FROM Products P
                JOIN Orderdetails OD ON P.ProductID = OD.ProductID
                JOIN Orders O ON OD.OrderID = O.OrderID
                GROUP BY Month
                ORDER BY Month DESC, Total_sales;
                
--         4.2. How does the average order value (AOV) change by month or week?
                
                -- MONTH
                
                SELECT DATE_FORMAT(O.OrderDate, '%Y-%m') AS Month,ROUND(SUM(OD.Quantity * P.Price) / COUNT(DISTINCT O.OrderID),2) AS AverageOrderValue
                FROM Orders O 
                JOIN OrderDetails OD ON O.OrderID = OD.OrderID
                JOIN Products P ON OD.ProductID = P.ProductID
                GROUP BY DATE_FORMAT(O.OrderDate, '%Y-%m')
                ORDER BY Month;
                
                -- WEEK
                
                SELECT YEAR(O.OrderDate) AS Year,WEEK(O.OrderDate, 1) 
                AS WeekNumber,ROUND(SUM(OD.Quantity * P.Price) / COUNT(DISTINCT O.OrderID),2) AS AverageOrderValue
                FROM Orders O
                JOIN OrderDetails OD ON O.OrderID = OD.OrderID
                JOIN Products P ON OD.ProductID = P.ProductID
                GROUP BY YEAR(O.OrderDate),WEEK(O.OrderDate, 1)
                ORDER BY Year, WeekNumber;