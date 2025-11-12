--         2. Customer insights
-- 2.1. Who are the top 10 customers by total revenue spent?
                
                SELECT C.CustomerID, C.CustomerName, SUM(Quantity*Price) AS Total_Revenue
				FROM customers C
                JOIN orders O ON C.CustomerID = O.CustomerID
                JOIN orderdetails OD ON O.OrderID = OD.OrderID
                JOIN products P ON OD.ProductID = P.ProductID 
                GROUP BY C.CustomerID, C.CustomerName
                ORDER BY Total_Revenue DESC
                LIMIT 10;
                
--         2.2. What is the repeat customer rate?

                WITH customer_order_counts AS (
                      SELECT O.CustomerID, COUNT(DISTINCT O.OrderID) AS total_orders
                      FROM Orders O
                      GROUP BY O.CustomerID
                      )
                      SELECT ROUND((COUNT(CASE 
                                               WHEN total_orders > 1 THEN 1 END) * 100.0) / COUNT(*), 2) AS RepeatCustomerRate
                      FROM customer_order_counts;

--         2.3. What is the average time between two consecutive orders for the same customer Region-wise?
                
                  WITH Consecutive_customer_orders AS(
					  SELECT C.CustomerID, C.CustomerName, C.RegionID, R.RegionName, O.OrderDate,
                      LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS Prev_OrderDate
                      FROM orders O
                      JOIN customers C ON O.CustomerID = C.CustomerID
                      JOIN regions R ON C.RegionID = R.RegionID
                      )
                      SELECT RegionName, AVG(DATEDIFF(OrderDate, Prev_OrderDate)) AS Avg_days_between_two_orders
                      FROM Consecutive_customer_orders
                      WHERE Prev_OrderDate IS NOT NULL
                      GROUP BY RegionName
                      ORDER BY Avg_days_between_two_orders;
                      
--         2.4. Customer Segment (based on total spend)
--             ▪ Platinum: Total Spend > 1500
--             ▪ Gold: 1000–1500
--             ▪ Silver: 500–999
--             ▪ Bronze: < 500

				SELECT C.CustomerID, C.CustomerName, SUM(OD.Quantity*P.Price) as Total_spend,
                      CASE
                           WHEN SUM(OD.Quantity*P.Price) > 1500 THEN 'Platinum'
                           WHEN SUM(OD.Quantity*P.Price) BETWEEN 1000 AND 1500 THEN 'Gold'
                           WHEN SUM(OD.Quantity*P.Price) BETWEEN 500 AND 999 THEN 'Silver'
                           ELSE 'Bronze'
					  END AS CustomerSegment
				 FROM customers C
                 JOIN orders O ON C.CustomerID = O.CustomerID
                 JOIN orderdetails OD ON O.OrderID = OD.OrderID
                 JOIN products P ON OD.ProductID = P.ProductID
                 GROUP BY C.CustomerID, C.CustomerName
                 ORDER BY Total_spend DESC;
                 
--         2.5. What is the customer lifetime value (CLV)?

                SELECT C.CustomerID, C.CustomerName, SUM(OD.Quantity*P.Price) as CustomerLifetimeValue
                FROM customers C
                JOIN orders O ON C.CustomerID = O.CustomerID
                JOIN orderdetails OD ON O.OrderID = OD.OrderID
				JOIN products P ON OD.ProductID = P.ProductID 
                GROUP BY C.CustomerID, C.CustomerName
				ORDER BY CustomerLifetimeValue DESC;