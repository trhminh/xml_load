-- This is a comment
/*
1. Comment 1
2. Hi
3. Comment 2
*/



-- 1. Explore data structure of 4 Dim + 1 Fact
SELECT TOP 10 *
FROM dim_region;

SELECT TOP 10 *
FROM dim_platform;

SELECT TOP 10 *
FROM [dbo].dim_segment;

SELECT TOP 10 *
FROM [dbo].[f_sale];
-- 2. Handle Data Quality if needed
SELECT *
FROM [dbo].[f_sale] fs
WHERE 1=1
	AND Segment_Id IS NULL;


-- 3. Transform data to Master Table Structure
WITH t_raw_data AS (
SELECT  DATEADD(DAY,1,EOMONTH(fs.sale_date, -1)) AS Sale_Date_Month
	,fs.sale_date
	,dr.Region
	,dp.Platform_Name AS "Platform"
	,ds.Segment_Code AS "Segment"
	,dc."Description" AS Customer_Type
	,fs.transactions 
	,fs.sales
	--,fs.ETL_DTTM
FROM dbo.f_sale fs
LEFT JOIN dbo.dim_region dr
	ON fs.Region_Code =dr.Region_Code
LEFT JOIN dbo.dim_platform dp
	ON fs.Platform_ID = dp.Platform_ID 
LEFT JOIN dbo.dim_segment ds
	ON fs.Segment_Id = ds.Id
LEFT JOIN dbo.dim_customertype dc
	ON fs.Customer_Code  = dc.Customer_Code
)

SELECT Sale_Date_Month
	   ,SUM(transactions) as Tottal_Transaction
	   ,SUM(sales) as Total_Sales
FROM t_raw_data
WHERE Sale_Date_Month = '2020-09-01'
GROUP BY Sale_Date_Month
ORDER BY Sale_Date_Month DESC


-- Solution 2: Excel bro
CREATE VIEW VW_MONTHLY_DATA_K21416C AS
SELECT  DATEADD(DAY,1,EOMONTH(fs.sale_date, -1)) AS Sale_Date_Month
	,fs.sale_date
	,dr.Region
	,dp.Platform_Name AS "Platform"
	,ds.Segment_Code AS "Segment"
	,dc."Description" AS Customer_Type
	,fs.transactions 
	,fs.sales
	--,fs.ETL_DTTM
FROM dbo.f_sale fs
LEFT JOIN dbo.dim_region dr
	ON fs.Region_Code =dr.Region_Code
LEFT JOIN dbo.dim_platform dp
	ON fs.Platform_ID = dp.Platform_ID 
LEFT JOIN dbo.dim_segment ds
	ON fs.Segment_Id = ds.Id
LEFT JOIN dbo.dim_customertype dc
	ON fs.Customer_Code  = dc.Customer_Code
