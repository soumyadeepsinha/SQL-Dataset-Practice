# 🧑‍💻 This is a SQL practice session!

# 📊 SQL Dataset Practice – Employee Data Analysis

A hands‑on SQL project using a **comprehensive synthetic Employee/HR dataset** to explore data analysis, query optimization, and insight generation.  
This repository demonstrates **practical SQL skills** on real‑world‑like data — from cleaning and transforming to extracting business‑ready insights.

---

## 📂 Dataset Overview

The dataset (source: [Employee Dataset on Kaggle](https://www.kaggle.com/datasets/ravindrasinghrana/employeedataset/data)) contains multiple HR‑related tables, including:

- **Employee Data** – Demographics, employment status, departments, titles, etc.
- **Training & Development Data** – Program names, costs, durations, and outcomes.
- **Recruitment Data** – Candidate details, job titles, hiring stages.
- **Employee Engagement Survey Data** – Engagement, satisfaction, and work‑life balance scores.

> _All data is synthetic and for learning purposes only._

---

## 🎯 Project Objectives

- **Data Cleaning & Preparation** – Normalize schemas, correct data types, handle nulls.
- **Exploratory Data Analysis (EDA)** – Understand workforce structure and patterns.
- **Advanced SQL Queries** – Filtering, grouping, aggregations, window functions.
- **Performance Optimization** – Use `TOP` / `OFFSET-FETCH`, indexes, and query tuning.
- **Business Insights** – Identify cost‑effective trainings, high‑engagement teams, attrition trends.

---

## 🛠️ Tech Stack

- **Microsoft SQL Server** – Primary RDBMS used for queries and analysis.
- **T‑SQL** – For DDL, DML, and analytical queries.
- **Git & GitHub** – Version control and portfolio hosting.

---

## 🔍 Important Query in SQL

- **CREATE TABLE** - Create a blank table
- **LOAD DATA LOCAL INFILE** - Load Data in blank table also known as **INSERT INTO TABLE**
- **SET SQL_SAFE_UPDATES = 0;** - Disable safe updates a table
- **SET SQL_SAFE_UPDATES = 1** - Allow safe update a table
- **SET @AgeLimit = 59;** - Set a variable and it can be used later

## 📝 Important Points

- **SQL_SAFE_UPDATES = 0** - Convert empty spaces to NULL to prevent truncation errors
- **TRIM** - Remove trailing spaces from any
- **LIMIT** - Retrieve Limited Rows from data
- **JOIN** - Join two tables to retrieve data
- **String Function** – Extract information from text data stored in a database
- **Concatenation Function** – Concatenatw two or more strings, columns,
- **STR_TO_DATE Function** - Converts Date in VARCHAR format to Date Format
- **Subquery** - Serves as an inner query to passes its results to the main query

## 📜 Example Queries

```sql
-- Organisation's spending for top 3 employees how passed the internal training
SELECT TOP 3 *
FROM dbo.Training_and_Development_Data
WHERE TrainingOutcome = 'Passed'
  AND TrainingType = 'Internal'
ORDER BY TrainingCost DESC;
```
