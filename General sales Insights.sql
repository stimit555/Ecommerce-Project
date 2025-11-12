-- Ecommerce Project

--     • Goal: Analyse the sales performance of products, categories, and regions.
--     • Database Schema Overview: We have 5 tables:
--     1. Customers
--     2. Products
--     3. Orders
--     4. OrderDetails
--     5. Regions

-- Questions:
--     1. General Sales Insights
--         1.1. What is the total revenue generated over the entire period?

		   SELECT SUM(Quantity*Price) AS Total_Revenue
           FROM orderdetails OD
           JOIN products P ON P.ProductID = OD.ProductID;
           
--         1.2. Revenue Excluding Returned Orders
		   
           SELECT SUM(Quantity*Price) AS Total_Revenue_Excluding_Returned_orders
           FROM orderdetails OD
           JOIN products P ON P.ProductID = OD.ProductID
           JOIN orders O ON OD.OrderID = O.OrderID
           WHERE IsReturned != 0;

--         1.3. Total Revenue per Year / Month

           SELECT SUM(Quantity*Price) AS Total_Yearly_Revenue, EXTRACT(YEAR FROM OrderDate) AS year
           FROM orderdetails OD
           JOIN products P ON P.ProductID = OD.ProductID
           JOIN orders O ON OD.OrderID = O.OrderID
           GROUP BY year;
           
           SELECT SUM(Quantity*Price) AS Total_Yearly_Revenue, EXTRACT(MONTH FROM OrderDate) AS month
           FROM orderdetails OD
           JOIN products P ON P.ProductID = OD.ProductID
           JOIN orders O ON OD.OrderID = O.OrderID
           GROUP BY month
           ORDER BY month;
           
--         1.4. Revenue by Product / Category
           
           SELECT ProductName, SUM(Quantity*Price) AS Total_Revenue
           FROM orderdetails OD
           JOIN products P ON P.ProductID = OD.ProductID
           JOIN orders O ON OD.OrderID = O.OrderID
           GROUP BY ProductName;
           
           SELECT Category, SUM(Quantity*Price) AS Total_Revenue
           FROM orderdetails OD
           JOIN products P ON P.ProductID = OD.ProductID
           JOIN orders O ON OD.OrderID = O.OrderID
           GROUP BY Category;
           
           
--         1.5. What is the average order value (AOV) across all orders?
                
                SELECT ROUND(SUM(OD.Quantity * P.Price) / COUNT(DISTINCT O.OrderID),2) AS AverageOrderValue
                FROM Orders O 
                JOIN OrderDetails OD ON O.OrderID = OD.OrderID
                JOIN Products P ON OD.ProductID = P.ProductID;
            
--         1.6. AOV per Year / Month

                SELECT YEAR(O.OrderDate) AS Year,MONTH(O.OrderDate) 
                AS Month,ROUND(SUM(OD.Quantity * P.Price) / COUNT(DISTINCT O.OrderID),2) AS AverageOrderValue
                FROM Orders O
                JOIN OrderDetails OD ON O.OrderID = OD.OrderID
                JOIN Products P ON OD.ProductID = P.ProductID
                GROUP BY YEAR(O.OrderDate),MONTH(O.OrderDate)
				ORDER BY Year, Month;

--         1.7. What is the average order size by region?

                SELECT R.RegionName,R.Country,ROUND(SUM(OD.Quantity) / COUNT(DISTINCT O.OrderID),2) AS AvgOrderSize
                FROM Orders O
                JOIN OrderDetails OD ON O.OrderID = OD.OrderID
                JOIN Customers C ON O.CustomerID = C.CustomerID
                JOIN Regions R ON C.RegionID = R.RegionID
                GROUP BY R.RegionName, R.Country
                ORDER BY AvgOrderSize DESC;