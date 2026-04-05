# Covid_project-SQL

##  Project Overview

This project focuses on analyzing global COVID-19 data using **SQL**.
The analysis explores infection rates, death rates, and vaccination progress across different countries and time periods.

The goal of this project is to demonstrate **SQL skills including joins, window functions, aggregations, and data analysis techniques**.

---

##  Objectives

* Analyze COVID-19 cases and deaths across countries
* Track vaccination progress over time
* Calculate key metrics like infection rate and death percentage
* Use SQL to derive meaningful insights from raw data

---

##  Tools & Technologies

* **PostgreSQL / SQL Server** – Data querying and analysis
* **SQL** – Joins, CTEs, Window Functions, Aggregations
* **GitHub** – Project hosting

---

##  Dataset Description

The project uses two main datasets:

1. **CovidDeaths**

   * Location, date, total cases, new cases, total deaths, population

2. **CovidVaccinations**

   * Location, date, new vaccinations, total vaccinations

---

##  Key SQL Concepts Used

*  Joins (INNER JOIN)
*  Common Table Expressions (CTE)
*  Window Functions (`SUM() OVER`)
*  Aggregate Functions (`SUM`, `AVG`, `MAX`)
*  Data Type Conversion
*  Filtering and Grouping

---

##  Key Analysis Performed

###  1. Total Cases vs Total Deaths

* Calculated death percentage to understand severity of COVID-19

###  2. Infection Rate by Country

* Compared total cases with population

###  3. Highest Infection Countries

* Identified countries with highest infection rates

###  4. Vaccination Progress (Rolling Total)

* Used window functions to calculate cumulative vaccinations

###  5. Population vs Vaccination Percentage

* Calculated percentage of population vaccinated

---

##  Example Query (Window Function)

```sql
WITH PopvsVac AS (
    SELECT 
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT)) 
        OVER (PARTITION BY dea.location ORDER BY dea.date) 
        AS RollingPeopleVaccinated
    FROM CovidDeaths dea
    JOIN CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
)
SELECT *,
       (RollingPeopleVaccinated * 100.0 / population) AS VaccinationPercentage
FROM PopvsVac;
```

---

##  Insights Derived

* Countries with higher population density showed faster spread
* Vaccination rollout varied significantly across countries
* Developed countries had faster vaccination rates
* Death rates varied based on healthcare infrastructure

---


##  How to Run

1. Import datasets into PostgreSQL / SQL Server
2. Create tables using provided SQL scripts
3. Run queries from `covid_analysis.sql`
4. Analyze results

---

##  Learning Outcomes

* Improved SQL query writing skills
* Hands-on experience with real-world datasets
* Understanding of window functions and CTEs
* Ability to derive insights from raw data

---

##  Future Improvements

* Integrate with Power BI for visualization
* Add more datasets for deeper analysis
* Optimize queries for performance

---
