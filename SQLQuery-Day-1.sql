IF OBJECT_ID('dbo.Employee_Data', 'U') IS NULL

BEGIN
CREATE TABLE Employee_Data (
	EmpID INT PRIMARY KEY,
	FirstName VARCHAR (100) NOT NULL,
	LastName VARCHAR (100) NOT NULL,
	StartDate DATE NOT NULL,
	ExitDate DATE,
	Title VARCHAR (100) NOT NULL,
	Supervisor VARCHAR (100) NOT NULL,
	ADEmail VARCHAR(254) NOT NULL,
	BusinessUnit VARCHAR (100) NOT NULL,
	EmployeeStatus VARCHAR (100) NOT NULL,
	DepartmentType VARCHAR(254) NOT NULL,
	Division VARCHAR (100) NOT NULL,
	DOB VARCHAR(250),
	State VARCHAR (100) NOT NULL,
	GenderCode VARCHAR (100) NOT NULL,
	LocationCode VARCHAR (100) NOT NULL,
	PerformanceScore VARCHAR (100) NOT NULL,
	CurrentEmployeeRating INT NOT NULL
);
END

-- Show Employee records table
SELECT * FROM Employee_Data;

-- Instert data into table
BULK INSERT dbo.Employee_Data
FROM 'C:\Users\Soumyadeep\Downloads\Dataset\employee_data.csv'
WITH (
   FIRSTROW = 2,              -- Skip header row
   FIELDTERMINATOR = ',',     -- Column separator
   ROWTERMINATOR = '\n',      -- Row separator
   TABLOCK
);

-- Update DOB with DATE format
UPDATE Employee_Data
SET DOB = CONVERT(date, DOB, 105);

-- Calculate employee's age
ALTER TABLE Employee_Data
ADD Age AS (
    DATEDIFF(YEAR, DOB, GETDATE()) 
    - CASE 
        WHEN (MONTH(DOB) > MONTH(GETDATE())) 
          OR (MONTH(DOB) = MONTH(GETDATE()) AND DAY(DOB) > DAY(GETDATE())) 
        THEN 1 ELSE 0 
      END
);

-- Show table senior employee at organisation
SELECT EmpID, FirstName, LastName, Title, DOB, Age, GenderCode FROM dbo.Employee_Data WHERE Age >= 60;

-- Show table with dataset with specific query
SELECT * FROM dbo.Employee_Data WHERE CurrentEmployeeRating >= 4;

-- Show table with employees - where their performance needs improvement
SELECT * FROM dbo.Employee_Data WHERE PerformanceScore = 'Needs Improvement';

-- Show male employees record
SELECT EmpID, FirstName, LastName, ADEmail from dbo.Employee_Data WHERE EmployeeStatus = 'Active' AND GenderCode = 'Male';

-- Show employees who are working till date in Software engineering dept
SELECT 
	EmpID, FirstName, LastName, Title, ADEmail, Division from dbo.Employee_Data
	WHERE ExitDate IS NULL AND DepartmentType = 'Software Engineering';

-- Create a table for training and development data
IF OBJECT_ID('dbo.Employee_Data', 'U') IS NULL
BEGIN
CREATE TABLE Training_and_Development_Data (
	EmployeeID INT PRIMARY KEY,
	TrainingDate VARCHAR (250) NOT NULL,
	TrainingProgramName VARCHAR (250) NOT NULL,
	TrainingType VARCHAR (250) NOT NULL,
	TrainingOutcome VARCHAR (250) NOT NULL,
	Location VARCHAR (250) NOT NULL,
	Trainer VARCHAR (250) NOT NULL,
	TrainingDuration INT NOT NULL,
	TrainingCost VARCHAR(250) NOT NULL
)
END

-- Show newly created table
SELECT * FROM Training_and_Development_Data;

-- Insert Bulk Data into the new table
BULK INSERT dbo.Training_and_Development_Data
FROM 'C:\Users\Soumyadeep\Downloads\Dataset\training_and_development_data.csv'
WITH (
   FIRSTROW = 2,              -- Skip header row
   FIELDTERMINATOR = ',',     -- Column separator
   ROWTERMINATOR = '\n',      -- Row separator
   TABLOCK
);

-- Show the table after the
SELECT * FROM dbo.Training_and_Development_Data;

ALTER TABLE dbo.Training_and_Development_Data
ALTER COLUMN TrainingCost FLOAT;

--Get totoal training cost spent by the organisation
SELECT SUM(TrainingCost) FROM dbo.Training_and_Development_Data;


-- Show top 10 emoployee's details who passed during training and cost for them in Descending order
SELECT TOP 10 * FROM dbo.Training_and_Development_Data
WHERE TrainingOutcome = 'Passed' AND TrainingType = 'Internal' ORDER BY TrainingCost DESC;

-- Get Employees record who passed or completed training
SELECT EmployeeID, TrainingDate, TrainingType, TrainingProgramName, TrainingOutcome
FROM dbo.Training_and_Development_Data WHERE TrainingOutcome IN ('Passed', 'Completed');

-- Fetch employees name who passed or completed the training and age below 60 by joining two different tables
SELECT 
	e.EmpID, 
	e.FirstName,
	e.LastName,
	e.Title,
	e.Age,
	t.TrainingDuration,
	t.TrainingOutcome
FROM Employee_Data e
JOIN 
	Training_and_Development_Data t ON e.EmpID = t.EmployeeID
WHERE
	t.TrainingOutcome IN ('Passed', 'Completed') AND e.Age <=59;


-- Create a new view
CREATE VIEW Employee_Training_Performance_Views
AS
SELECT 
	e.EmpID, 
	e.FirstName, 
	e.LastName,
	t.TrainingOutcome,
	t.TrainingCost

FROM dbo.Employee_Data e
JOIN 
	Training_and_Development_Data t ON e.EmpID = t.EmployeeID
WHERE e.Age >= 59;


SELECT * FROM dbo.Employee_Training_Performance_Views;