# 🎬 Netflix Content Analysis Project — ELT with Python & SQL Server

## 📌 Project Overview
This project demonstrates a complete ELT (Extract, Load, Transform) pipeline using the Netflix dataset, built with Python and SQL Server. 
The goal was to transform raw content data into actionable business insights through structured querying and data cleaning.

# 🛠️ Tools & Technologies
-- Python: pandas, pyodbc for data extraction and loading
-- SQL Server: for data transformation and querying
-- Jupyter Notebook: for Python scripting
-- SQL: CTEs, CASE statements, GROUP BY, date functions, string functions

# 🔄 ELT Workflow
-- Extract: Loaded the raw Netflix dataset (CSV) using Python.
-- Load: Inserted the data into a SQL Server table using pyodbc.
-- Transform: Performed data cleaning and business logic transformation directly in SQL Server.

# 📊 Business Questions Solved

##  Director Content Breakdown
➤ Counted the number of Movies and TV Shows created by each director — included only those active in both formats.

## Top Comedy-Producing Country
➤ Identified the country with the highest number of comedy movies.

## Most Active Director Per Year
➤ Based on date_added, determined which director had the most movies released each year.

## Average Movie Duration by Genre
➤ Cleaned duration field and calculated average duration for each genre.

## Cross-Genre Creators
➤ Found directors who created content in both Horror and Comedy genres.📊 Business Questions Solved
Director Content Breakdown
➤ Counted the number of Movies and TV Shows created by each director — included only those active in both formats.

# 📈 Key Skills Demonstrated
-- Building a full ELT pipeline with Python and SQL
-- Data transformation and cleansing in SQL Server
-- Writing business-driven SQL queries
-- Handling messy real-world data (e.g., mixed duration formats, missing values)
-- Answering business questions with clear logic and structure

# 📎 Dataset
https://www.kaggle.com/datasets/shivamb/netflix-shows

