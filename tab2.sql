--1. Explore data structure 4dim + 1fact
SELECT TOP 10 * 
FROM dbo.dimRegion

SELECT TOP 10 * 
FROM dbo.dimPlatform

SELECT TOP 10 * 
FROM dbo.dimSegment

SELECT TOP 10 * 
FROM dbo.[dimCustomerType]

--2. Handle data quality
SELECT * 
FROM dbo.[dimSegment]
WHERE 1=1
	AND Segment_Code = 'NULL'

--3. Transform data to Master Table structure
WITH t_rawdata as(
SELECT DATEADD(DAY,1,EOMONTH(fs.sale_date, -1)) AS Sales_date_month
,dr.Region as region
,dp.Platform_Name as [platform]
,ds.Segment_Code as segment
,dc.[Description] as customer_type


FROM dbo.[Transaction] fs
LEFT JOIN dbo.dimRegion dr
	ON fs.Region_Code = dr.Region_Code
LEFT JOIN dbo.dimPlatform dp
	ON fs.Platform_ID = dp.Platform_ID
LEFT JOIN dbo.dimSegment ds
	ON fs.Segment_Id = ds.Id
LEFT JOIN dbo.dimCustomerType dc
	ON fs.Customer_Code = dc.Customer_Code
	)

SELECT Sales_date_month,
	SUM(transactions) as total_transc
	,SUM(sales) as total_sales
FROM t_rawdata


	

