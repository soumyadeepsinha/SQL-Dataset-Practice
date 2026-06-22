USE practice;
-- Drop table if exists
DROP TABLE IF EXISTS EmployeeData;
-- create table
CREATE TABLE EmployeeData (
    EmpID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    StartDate VARCHAR(20),
    ExitDate VARCHAR(20),
    Title VARCHAR(100),
    Supervisor VARCHAR(100),
    ADEmail VARCHAR(100),
    BusinessUnit VARCHAR(50),
    EmployeeStatus VARCHAR(50),
    EmployeeType VARCHAR(50),
    PayZone VARCHAR(20),
    EmployeeClassificationType VARCHAR(50),
    TerminationType VARCHAR(50),
    TerminationDescription VARCHAR(500),
    DepartmentType VARCHAR(100),
    Division VARCHAR(100),
    DOB VARCHAR(20),
    State VARCHAR(10),
    JobFunctionDescription VARCHAR(100),
    GenderCode VARCHAR(20),
    LocationCode VARCHAR(50),
    RaceDesc VARCHAR(50),
    MaritalDesc VARCHAR(50),
    `Performance Score` VARCHAR(50),
    `Current Employee Rating` INT
);
-- Insert data into table
LOAD DATA LOCAL INFILE '/Users/soumyadeepsinha/Documents/software/dataset/employee_data.csv' INTO TABLE EmployeeData FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' -- Or '\r\n' if the CSV was created on a Windows machine
IGNORE 1 ROWS;
-- This ignores the header row in your CSV
-- show table
SELECT *
FROM EmployeeData;
-- 1. Disable safe updates
SET SQL_SAFE_UPDATES = 0;
-- 2. Convert empty spaces to NULL to prevent truncation errors
UPDATE EmployeeData
SET DOB = NULL
WHERE TRIM(DOB) = '';
-- 3. Convert the string dates to MySQL format (YYYY-MM-DD)
UPDATE EmployeeData
SET DOB = STR_TO_DATE(DOB, '%d-%m-%Y')
WHERE DOB IS NOT NULL;
-- 4. Change DOB to DATE type and add Age column
ALTER TABLE EmployeeData
MODIFY COLUMN DOB DATE,
    ADD COLUMN Age INT
AFTER DOB;
-- 5. Calculate ages
UPDATE EmployeeData
SET Age = TIMESTAMPDIFF(YEAR, DOB, CURDATE())
WHERE DOB IS NOT NULL;
-- 6. Re-enable safe updates
SET SQL_SAFE_UPDATES = 1;
-- Show table senior employee at organisation
SELECT EmpID,
    FirstName,
    LastName,
    Title,
    DOB,
    Age,
    GenderCode
FROM EmployeeData
WHERE Age >= 60;
-- Show table with dataset with specific query
-- Show table with employees - where their performance needs improvement
SELECT *
FROM EmployeeData
WHERE `Performance Score` = 'Needs Improvement';
-- Show male employees record
SELECT EmpID,
    FirstName,
    LastName,
    ADEmail
from EmployeeData
WHERE EmployeeStatus = 'Active'
    AND GenderCode = 'Male';
-- Show employees from Software engineering dept with Concatenation function
SELECT EmpID,
    CONCAT_WS(' ', FirstName, LastName) AS FullName,
    Title,
    ADEmail,
    Division,
    ExitDate
from EmployeeData
WHERE DepartmentType = 'Software Engineering';
-- Create a table for training and development data
CREATE TABLE IF NOT EXISTS Training_and_Development_Data (
    EmployeeID INT PRIMARY KEY,
    TrainingDate DATE NOT NULL,
    -- Better for searching dates
    TrainingProgramName VARCHAR(250) NOT NULL,
    TrainingType VARCHAR(250) NOT NULL,
    TrainingOutcome VARCHAR(250) NOT NULL,
    Location VARCHAR(250) NOT NULL,
    Trainer VARCHAR(250) NOT NULL,
    TrainingDuration INT NOT NULL,
    TrainingCost DECIMAL(10, 2) NOT NULL -- Better for currency/money
);
-- Show newly created table
SELECT *
FROM Training_and_Development_Data;
-- Insert data into table 
LOAD DATA LOCAL INFILE '/Users/soumyadeepsinha/Documents/software/dataset/training_and_development_data.csv' INTO TABLE Training_and_Development_Data FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' -- Or '\r\n' if the CSV was created on a Windows machine
IGNORE 1 ROWS;
-- This ignores the header row in your CSV
-- Alter column
ALTER TABLE Training_and_Development_Data
MODIFY COLUMN TrainingCost DECIMAL(10, 2);
-- Get totoal training cost spent by the organisation
SELECT SUM(TrainingCost)
FROM Training_and_Development_Data;
-- Show top 10 emoployee's details who passed during training and cost for them in Descending order
SELECT *
FROM Training_and_Development_Data
WHERE TrainingOutcome = 'Passed'
    AND TrainingType = 'Internal'
ORDER BY TrainingCost DESC
LIMIT 10;
-- Get Employees record who passed or completed training
SELECT EmployeeID,
    TrainingDate,
    TrainingType,
    TrainingProgramName,
    TrainingOutcome
FROM Training_and_Development_Data
WHERE TrainingOutcome IN ('Passed', 'Completed');
-- JOIN Function
-- Fetch employees name who passed or completed the training
-- Senior Employees (Age should be above 60 years) who Exit the company
-- Converting Varchar to Date Format
-- Using Subquery
SELECT e.EmpID,
    CONCAT_WS(' ', e.FirstName, e.LastName) AS 'Full Name',
    e.Title,
    e.Age,
    (
        SELECT DATE_FORMAT(STR_TO_DATE(e.StartDate, '%d-%b-%y'), '%d-%m-%Y')
    ) AS 'Joining Date',
    (
        SELECT DATE_FORMAT(STR_TO_DATE(e.ExitDate, '%d-%b-%y'), '%d-%m-%Y')
    ) AS 'Leaving Date',
    t.TrainingDuration,
    t.TrainingOutcome
FROM EmployeeData e
    JOIN Training_and_Development_Data t ON e.EmpID = t.EmployeeID
WHERE e.ExitDate IS NOT NULL
    AND e.ExitDate != '' -- Added: Excludes empty strings
    AND e.ExitDate != ' ' -- Added: Excludes strings with just a blank space
    AND t.TrainingOutcome IN ('Passed', 'Completed')
    AND e.Age > 59;
-- Find Employees who crossed 60 years age and currently not working 
SELECT e.EmpID,
    CONCAT_WS(' ', e.FirstName, e.LastName) AS 'Full Name',
    e.Title,
    e.Age,
    (
        SELECT DATE_FORMAT(STR_TO_DATE(e.StartDate, '%d-%b-%y'), '%d-%m-%Y')
    ) AS 'Joining Date',
    (
        SELECT DATE_FORMAT(STR_TO_DATE(e.ExitDate, '%d-%b-%y'), '%d-%m-%Y')
    ) AS 'Leaving Date',
    t.TrainingDuration,
    t.TrainingOutcome
FROM EmployeeData e
    JOIN Training_and_Development_Data t ON e.EmpID = t.EmployeeID
WHERE (
        e.ExitDate IS NULL
        OR TRIM(e.ExitDate) = ''
    )
    AND e.Age > 59;
-- Find Employees who are currently Working and below 60 years old
SET @AgeLimit = 59;
SELECT e.EmpID,
    CONCAT_WS(' ', e.FirstName, e.LastName) AS 'Full Name',
    e.Title,
    e.Age,
    (
        SELECT DATE_FORMAT(STR_TO_DATE(e.StartDate, '%d-%b-%y'), '%d-%m-%Y')
    ) AS 'Joining Date',
    (
        SELECT DATE_FORMAT(STR_TO_DATE(e.ExitDate, '%d-%b-%y'), '%d-%m-%Y')
    ) AS 'Leaving Date',
    t.TrainingDuration,
    t.TrainingOutcome
FROM EmployeeData e
    JOIN Training_and_Development_Data t ON e.EmpID = t.EmployeeID
WHERE (
        e.ExitDate IS NULL
        OR TRIM(e.ExitDate) = ''
    )
    AND t.TrainingOutcome IN ('Passed', 'Completed')
    AND e.Age < @AgeLimit;
-- Create a new view with String & Concatenation function
-- Using variable
CREATE OR REPLACE VIEW Employee_Training_Performance_Views AS
SELECT e.EmpID,
    CONCAT(LEFT(e.FirstName, 1), '. ', e.LastName) AS FullName,
    e.Age,
    e.Title,
    UPPER(t.TrainingOutcome) AS TrainingResult,
    t.TrainingCost
FROM EmployeeData e
    JOIN Training_and_Development_Data t ON e.EmpID = t.EmployeeID
WHERE e.Age >= 59;
-- Fetch the created view
SELECT *
FROM Employee_Training_Performance_Views;
-- Show Software Engineer who passed the training with minimum spend (creating values with constants)
SELECT EmpID,
    FirstName,
    LastName,
    'Software Engineer' AS Designation,
    TrainingCost
FROM Employee_Training_Performance_Views
WHERE (
        TrainingOutcome LIKE '%Completed%'
        OR TrainingOutcome LIKE '%Passed%'
    )
ORDER BY CAST(TrainingCost AS DECIMAL(10, 2)) DESC;
-- Show total training cost for each Job role (title) in Descending or Ascending order
SELECT Title AS Designation,
    SUM(TrainingCost) AS TrainingCost
FROM Employee_Training_Performance_Views
GROUP BY Title
ORDER BY TrainingCost ASC;
-- Get  Average training cost for department
SELECT DepartmentType AS Department,
    AVG(TrainingCost) AS AverageTrainingCost
FROM EmployeeData e
    JOIN Training_and_Development_Data t ON e.EmpID = t.EmployeeID
GROUP BY DepartmentType
ORDER BY AverageTrainingCost DESC;