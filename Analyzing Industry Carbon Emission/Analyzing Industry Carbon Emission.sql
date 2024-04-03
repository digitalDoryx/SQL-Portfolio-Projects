/**
 DATA ANALYSIS PORTFOLIO PROJECT: ANALYSING INDUSTRY CARBON EMISSION BY DIGITALDORYX
 				Keywords: Select, Sum, Avg, Group By, Order By, Alias
 			   dataset: https://doi.org/10.6084/m9.figshare.c.5408100.v1
*/

-- 1. This shows me all the data on the database
SELECT *
		FROM productLevel;
		

-- 2. Identifying the Company with the Highest Carbon Emission Contribution.
SELECT TOP 10 Company, 
		SUM([Product's carbon footprint (PCF, kg CO2e)]) AS total_carbon_emission ,
		AVG([Product's carbon footprint (PCF, kg CO2e)]) AS avg_carbon_emission
		FROM productLevel
		GROUP BY Company
		ORDER BY total_carbon_emission DESC;
		
-- 3. Discovering the Products with the highest Carbon Footprint 
--within Gamesa Corporacion, the company with the highest carbon emissions.
SELECT [Product name (and functional unit)] AS product_name,
		SUM([Product's carbon footprint (PCF, kg CO2e)]) AS total_carbon_emission
		FROM productLevel
		WHERE Company Like 'Gamesa%'
		GROUP BY [Product name (and functional unit)]
		ORDER BY total_carbon_emission DESC;

--4. The country with the highest average carbon footprint (PCF) per product
SELECT TOP 10 [Country (where company is incorporated)] AS Country, 
		SUM([Product's carbon footprint (PCF, kg CO2e)]) AS Total_carbon_emission,
		AVG([Product's carbon footprint (PCF, kg CO2e)]) AS Avg_carbon_emission
		FROM productLevel
		GROUP BY [Country (where company is incorporated)]
		ORDER BY AVG([Product's carbon footprint (PCF, kg CO2e)]) DESC;

-- 5. What is the pattern observed in the carbon footprints (PCFs) across the years, was it increasing or reducing?
SELECT [Year of reporting], AVG([Product's carbon footprint (PCF, kg CO2e)]) AS Avg_carbon_emission
		FROM productLevel
		GROUP BY [Year of reporting]
		ORDER BY [Year of reporting];

-- 6. Finding the average carbon footprint (PCF) for each product
SELECT TOP 20 [Product name (and functional unit)] AS Product_Name, 
		AVG([Product's carbon footprint (PCF, kg CO2e)]) AS Avg_carbon_emission
		FROM productLevel
		GROUP BY [Product name (and functional unit)]
		ORDER BY Avg_carbon_emission DESC;

-- 7. Which industry has demonstrated the most notable decline in carbon footprints (PCFs) throughout the years?
SELECT [Year of reporting] AS Industry_Year, [Company's GICS Industry Group] AS Industry_Group,
		AVG([Product's carbon footprint (PCF, kg CO2e)]) AS Avg_carbon_emission
		FROM productLevel
		GROUP BY [Year of reporting] ,[Company's GICS Industry Group]
		ORDER BY Industry_Group , Industry_Year ASC, Avg_carbon_emission ASC;

--8. What is the contribution of each industry group to the total global emissions
SELECT [Company's GICS Industry Group] AS Industry_Group, 
		AVG([Product's carbon footprint (PCF, kg CO2e)]) AS Avg_carbon_emission
		FROM productLevel
		GROUP BY [Company's GICS Industry Group]
		ORDER BY Avg_carbon_emission DESC;