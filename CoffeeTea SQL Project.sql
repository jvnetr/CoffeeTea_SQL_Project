
Select*
From 
	[Coffee Project]..BudgetandPerformance

Select*
From 
	[Coffee Project]..Location

Select* 
From 
	[Coffee Project]..Product

Select 
	bp.Date, 
	bp.[Area Code], 
	bp.[Product ID], 
	bp.[Profit], 
	bp.[Budget Profit], 
	p.[Product Name], 
	p.[Product Type], 
	p.[Caffeine Type]
From 
	[Coffee Project]..BudgetandPerformance bp
Inner join 
	[Coffee Project]..Product p
		On bp.[Product ID] = p.[Product ID]
 
 -- To calculate overall profitability based on products
Select	
	bp.[Product ID],
	p.[Product Name],
	p.[Product Type],
	p.[Caffeine Type],
	SUM(bp.[Profit]) as [Total Profit],
	SUM(bp.[Budget Profit]) as [Total Budget Profit], 
	SUM(bp.[Profit]) - SUM(bp.[Budget Profit]) as [Profit Variance],
	((SUM(bp.[Profit]) - SUM(bp.[Budget Profit])) / SUM(bp.[Budget Profit])) * 100 as [Percentage Profit Variance]
From 
	[Coffee Project]..BudgetandPerformance bp
Inner join 
	[Coffee Project]..Product p
		On bp.[Product ID] = p.[Product ID]
Group by 
	bp.[Product ID],
	p.[Product Name],
	p.[Product Type],
	p.[Caffeine Type];

--Profitability based on region (area code)
Select	
	bp.[Area Code],
	SUM(bp.[Profit]) as [Total Profit],
	SUM(bp.[Budget Profit]) as [Total Budget Profit], 
	SUM(bp.[Profit]) - SUM(bp.[Budget Profit]) as [Profit Variance],
	((SUM(bp.[Profit]) - SUM(bp.[Budget Profit])) / SUM(bp.[Budget Profit])) * 100 as [Percentage Profit Variance]
From 
	[Coffee Project]..BudgetandPerformance bp
Group by 
	bp.[Area Code]

-- To calculate the profitability trends
Select 
    YEAR(bp.Date) as [Year],
    SUM(bp.[Profit]) as [Total Profit],
    SUM(bp.[Budget Profit]) as [Total Budget Profit],
    SUM(bp.[Profit]) - SUM(bp.[Budget Profit]) as [Profit Variance],
    ((SUM(bp.[Profit]) - SUM(bp.[Budget Profit])) / SUM(bp.[Budget Profit])) * 100 as [Profit Variance %]
From 
    [Coffee Project]..BudgetandPerformance bp
Group by 
    YEAR(bp.Date), 
    MONTH(bp.Date)
Order by 
    [Year]

--Calculate the most profitable to least profitable products
Select	
	bp.[Product ID],
	p.[Product Name],
	p.[Product Type],
	p.[Caffeine Type],
	SUM(bp.[Profit]) as [Total Profit]
From 
	[Coffee Project]..BudgetandPerformance bp
Inner join 
	[Coffee Project]..Product p
		On bp.[Product ID] = p.[Product ID]
Group by 
	bp.[Product ID],
	p.[Product Name],
	p.[Product Type],
	p.[Caffeine Type]
Order by 
	[Total Profit] DESC

--To calculate profitability contribution based on the area code
Select 
    bp.[Area Code],
    SUM(bp.[Profit]) as [Total Profit],
    (SUM(bp.[Profit]) * 100.0) / (Select SUM(bp.[Profit]) From [Coffee Project]..BudgetandPerformance bp) as [Contribution %]
From 
    [Coffee Project]..BudgetandPerformance bp
Group by 
    bp.[Area Code]
Order by 
    [Contribution %] DESC;

-- Showcases the most profitable product in each area code market
Select
	bp.[Area Code],
	l.[Market],
	p.[Product Name],
	SUM(bp.[Profit]) as [Total Profit]
From 
	[Coffee Project]..BudgetandPerformance bp
Inner join 
	[Coffee Project]..Product p
		On bp.[Product ID] = p.[Product ID]
Inner Join
	[Coffee Project]..Location l
		On bp.[Area Code] = l.[Area Code]
Group by 
	bp.[Area Code], 
    l.[Market],  
    p.[Product Name]
Order by
	[Total Profit] DESC

-- Showcases the most profitable market 
Select
	bp.[Area Code],
	l.[Market],
	SUM(bp.[Profit]) as [Total Profit]
From 
	[Coffee Project]..BudgetandPerformance bp
Inner Join
	[Coffee Project]..Location l
		On bp.[Area Code] = l.[Area Code]
Group by 
	bp.[Area Code], 
    l.[Market]
Order by
	[Total Profit] DESC

-- Showcases products with highest contribution margin
Select
	bp.[Area Code],
	p.[Product Name],
	SUM(bp.[Profit]) as [Total Profit],
	SUM(bp.[COGS]) as [Total COGS],
	SUM(bp.[Profit]) - SUM(bp.[COGS]) as [Contribution Margin]
From 
	[Coffee Project]..BudgetandPerformance bp
Inner join 
	[Coffee Project]..Product p
		On bp.[Product ID] = p.[Product ID]
Group by 
	bp.[Area Code], 
	p.[Product Name]
Order by
	[Contribution Margin] DESC;