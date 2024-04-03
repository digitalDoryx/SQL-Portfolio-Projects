--						DIGITALDORYX
--					MOTORCYCLE MONTHLY SALES REVENUE

--Keywords: Format, Convert, Over, Left, Pivot Table, Subquery, OVER, Partition By, In, For
/*Motorcycle question 
The board of directors want to gain a better understanding of wholesale revenue by product line, 
and how this varies month-to-month and across warehouses. You have been tasked 
with calculating net revenue for each product line, grouping results by month and warehouse.
*/

--1. Extract all data from Motorcycle Sales Table
SELECT *
	FROM [Motorcycle Sales].dbo.Sales

--2. Wholesale Monthly Revenue Trend
SELECT FORMAT(CONVERT(date, LEFT(order_date,10)), 'yyyy-MM') AS month, warehouse, product_line, SUM(quantity * unit_price) AS net_revenue
	FROM [Motorcycle Sales].dbo.Sales
	WHERE client_type = 'Wholesale'
	GROUP BY FORMAT(CONVERT(date, LEFT(order_date,10)), 'yyyy-MM'), warehouse, product_line
	ORDER BY month, warehouse;

--3. Retail Monthly Revenue Trend
SELECT FORMAT(CONVERT(date, LEFT(order_date,10)), 'yyyy-MM') AS month, warehouse, product_line, SUM(quantity * unit_price) AS net_revenue
	FROM [Motorcycle Sales].dbo.Sales
	WHERE client_type = 'Retail'
	GROUP BY FORMAT(CONVERT(date, LEFT(order_date,10)), 'yyyy-MM'), warehouse, product_line
	ORDER BY month, warehouse;

--4. Wholesale Product Line Net Revenue generated in the three Warehouses
SELECT product_line, 
	[central] AS central_warehouse_revenue, 
	[north] AS north_warehouse_revenue, 
	[west] AS west_warehouse_revenue
		FROM (SELECT product_line, warehouse, SUM(quantity * unit_price) AS wholesale_net_revenue
		FROM [Motorcycle Sales].dbo.Sales
		WHERE client_type = 'Wholesale'
		GROUP BY product_line, warehouse) AS revenuebyproductandwarehouse
		PIVOT(SUM(wholesale_net_revenue) FOR warehouse in ([central], [north], [west])) AS pivottable
		ORDER BY product_line;
	
--5. Retail Product Line Net Revenue generated in the three Warehouses
SELECT product_line, 
	[central] AS central_warehouse_revenue, 
	[north] AS north_warehouse_revenue, 
	[west] AS west_warehouse_revenue
		FROM (SELECT product_line, warehouse, SUM(quantity * unit_price) AS retail_net_revenue
		FROM [Motorcycle Sales].dbo.Sales
		WHERE client_type = 'Retail'
		GROUP BY product_line, warehouse) AS revenuebyproductandwarehouse
		PIVOT(SUM(retail_net_revenue) FOR warehouse in ([central], [north], [west])) AS pivottable
		ORDER BY product_line;

--6.. Total Revenue generated across the three Warehouse from wholesale and retail clients
SELECT client_type, 
	[central] AS central_warehouse_revenue, 
	[north] AS north_warehouse_revenue, 
	[west] AS west_warehouse_revenue
		FROM (SELECT client_type, warehouse, SUM(quantity * unit_price) AS client_net_revenue
		FROM [Motorcycle Sales].dbo.Sales
		GROUP BY client_type, warehouse) AS revenuebyclienttypeandwarehouse
		PIVOT(SUM(client_net_revenue) FOR warehouse in ([central], [north], [west])) AS pivottable
		ORDER BY client_type;

--7.. Total Product line Sales from wholesale and retail clients
SELECT product_line, 
	[wholesale] AS wholesale_revenue, 
	[retail] AS retail_revenue
		FROM (SELECT product_line, client_type, SUM(quantity * unit_price) AS net_revenue
		FROM [Motorcycle Sales].dbo.Sales
		WHERE client_type IN ('Wholesale', 'Retail')
		GROUP BY product_line, client_type) AS revenuebyproductandclienttype
		PIVOT(SUM(net_revenue) FOR client_type in ([wholesale], [Retail])) AS pivottable
		ORDER BY product_line;

--8. Product Line Growth Rate: This calculates the current price minus the previous price
--divided by the previous price
SELECT product_line,
	[Wholesale] as wholesale_growthrate,
	[Retail] as retail_growthrate
	FROM (
	SELECT product_line, client_type, (SUM(quantity * unit_price) - LAG(SUM(quantity * unit_price)) 
		OVER (PARTITION BY product_line, client_type ORDER BY order_date)) / LAG(SUM(quantity * unit_price))
		OVER (PARTITION BY product_line, client_type ORDER BY order_date) AS growth_rate
		FROM [Motorcycle Sales].dbo.Sales
		WHERE client_type IN ('Wholesale', 'Retail')
		GROUP BY order_date, product_line, client_type) AS GrowthRatebyProductandClienttype
		PIVOT(SUM(growth_rate) for client_type in ([Wholesale], [Retail])) AS PivotTable
		ORDER BY product_line;