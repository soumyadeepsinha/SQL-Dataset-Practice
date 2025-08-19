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
	DOB DATE,
	State VARCHAR (100) NOT NULL,
	GenderCode VARCHAR (100) NOT NULL,
	LocationCode VARCHAR (100) NOT NULL,
	PerformanceScore VARCHAR (100) NOT NULL,
	CurrentEmployeeRating INT NOT NULL
);
END

-- Show blank table
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

-- Change DOB column from datatype from Date to varchar
ALTER TABLE Employee_Data
ALTER COLUMN DOB VARCHAR(250);

-- Show table after inserting dataset
SELECT * FROM dbo.Employee_Data

-- Show table with dataset with specific query
SELECT * FROM dbo.Employee_Data WHERE CurrentEmployeeRating >= 4;

SELECT EmpID, FirstName, LastName, ADEmail from dbo.Employee_Data WHERE EmployeeStatus = 'Active' AND GenderCode = 'Male';

-- Show employees who are working till date
SELECT 
	EmpID, FirstName, LastName, Title, ADEmail, Division from dbo.Employee_Data
	WHERE ExitDate IS NULL AND DepartmentType = 'Software Engineering';

-- Create a table for training and development data
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