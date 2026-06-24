-- AdventureWorksT sample database forMicrosoft Azure
-- Check version and available database on Azure
SELECT @@VERSION;
SELECT *
FROM sys.databases;

SELECT *
FROM [SalesLT].[Customer];

-- Show customer data
SELECT [CustomerID],
  CONCAT_WS(' ', [FirstName], [LastName]) AS [FullName],
  [EmailAddress],
  [Phone]
FROM [SalesLT].[Customer];

-- Verify a specific customer details by ID
SELECT [CustomerID],
  [FirstName],
  [LastName]
FROM [SalesLT].[Customer]
WHERE [CustomerID] = 29741;

-- Show product data
SELECT [ProductID],
  [Name],
  [ProductModelID],
  [ListPrice],
  [SellStartDate],
  [SellEndDate],
  [DiscontinuedDate]
FROM [SalesLT].[Product]

-- Show sales order data
SELECT [CustomerID],
  [SalesOrderID],
  [ShipMethod],
  [DueDate],
  [TotalDue]
FROM [SalesLT].[SalesOrderHeader]
ORDER BY [TotalDue] DESC;

-- Show sales order detail data
SELECT [SalesOrderID],
  [ProductID],
  [OrderQty],
  [UnitPrice],
  [LineTotal]
FROM [SalesLT].[SalesOrderDetail]
ORDER BY [LineTotal] DESC;

-- Join sales order header and detail data according to customer ID
SELECT soh.[CustomerID],
  CONCAT_WS(' ', c.[FirstName], c.[LastName]) AS [FullName],
  sod.[SalesOrderID],
  sod.[ProductID],
  sod.[OrderQty],
  soh.[TotalDue]
FROM [SalesLT].[SalesOrderDetail] sod
  INNER JOIN [SalesLT].[SalesOrderHeader] soh ON sod.[SalesOrderID] = soh.[SalesOrderID]
  LEFT JOIN [SalesLT].[Customer] c ON soh.[CustomerID] = c.[CustomerID]
ORDER BY soh.[TotalDue] ASC;

-- Show product details with specific conditions like price
SELECT
  [ProductID], [ProductCategoryID], [Name], [ProductNumber], [Color], [Size], [StandardCost], [ListPrice]
FROM [SalesLT].[Product]
WHERE [StandardCost] < 1000
  AND [Size] IS NOT NULL
ORDER BY [ListPrice] ASC;

-- Find customers with a specific address type
SELECT c.[CustomerID],
  CONCAT_WS(' ', c.[FirstName], c.[MiddleName], c.[LastName]) AS [FullName],
  c.[EmailAddress], c.[SalesPerson], ca.[AddressType]
FROM [SalesLT].[Customer] c
  JOIN [SalesLT].[CustomerAddress] ca ON ca.[CustomerID] = c.[CustomerID]
WHERE ca.[AddressType] = 'Main Office';


