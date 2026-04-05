-- Creating table

CREATE TABLE covid_deaths (
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date DATE,
    total_cases DOUBLE PRECISION,
    new_cases DOUBLE PRECISION,
    new_cases_smoothed DOUBLE PRECISION,
    total_deaths DOUBLE PRECISION,
    new_deaths DOUBLE PRECISION,
    new_deaths_smoothed DOUBLE PRECISION,
    total_cases_per_million DOUBLE PRECISION,
    new_cases_per_million DOUBLE PRECISION,
    new_cases_smoothed_per_million DOUBLE PRECISION,
    total_deaths_per_million DOUBLE PRECISION,
    new_deaths_per_million DOUBLE PRECISION,
    new_deaths_smoothed_per_million DOUBLE PRECISION,
    reproduction_rate DOUBLE PRECISION,
    icu_patients DOUBLE PRECISION,
    icu_patients_per_million DOUBLE PRECISION,
    hosp_patients DOUBLE PRECISION,
    hosp_patients_per_million DOUBLE PRECISION,
    weekly_icu_admissions DOUBLE PRECISION,
    weekly_icu_admissions_per_million DOUBLE PRECISION,
    weekly_hosp_admissions DOUBLE PRECISION,
    weekly_hosp_admissions_per_million DOUBLE PRECISION,
    new_tests DOUBLE PRECISION,
    total_tests DOUBLE PRECISION,
    total_tests_per_thousand DOUBLE PRECISION,
    new_tests_per_thousand DOUBLE PRECISION,
    new_tests_smoothed DOUBLE PRECISION,
    new_tests_smoothed_per_thousand DOUBLE PRECISION,
    positive_rate DOUBLE PRECISION,
    tests_per_case DOUBLE PRECISION,
    tests_units TEXT,
    total_vaccinations DOUBLE PRECISION,
    people_vaccinated DOUBLE PRECISION,
    people_fully_vaccinated DOUBLE PRECISION,
    new_vaccinations DOUBLE PRECISION,
    new_vaccinations_smoothed DOUBLE PRECISION,
    total_vaccinations_per_hundred DOUBLE PRECISION,
    people_vaccinated_per_hundred DOUBLE PRECISION,
    people_fully_vaccinated_per_hundred DOUBLE PRECISION,
    new_vaccinations_smoothed_per_million DOUBLE PRECISION,
    stringency_index DOUBLE PRECISION,
    population DOUBLE PRECISION,
    population_density DOUBLE PRECISION,
    median_age DOUBLE PRECISION,
    aged_65_older DOUBLE PRECISION,
    aged_70_older DOUBLE PRECISION,
    gdp_per_capita DOUBLE PRECISION,
    extreme_poverty DOUBLE PRECISION,
    cardiovasc_death_rate DOUBLE PRECISION,
    diabetes_prevalence DOUBLE PRECISION,
    female_smokers DOUBLE PRECISION,
    male_smokers DOUBLE PRECISION,
    handwashing_facilities DOUBLE PRECISION,
    hospital_beds_per_thousand DOUBLE PRECISION,
    life_expectancy DOUBLE PRECISION,
    human_development_index DOUBLE PRECISION
);





CREATE TABLE covid_vaccinations (
    iso_code TEXT,
    continent TEXT,
    location TEXT,
    date DATE,
    new_tests DOUBLE PRECISION,
    total_tests DOUBLE PRECISION,
    total_tests_per_thousand DOUBLE PRECISION,
    new_tests_per_thousand DOUBLE PRECISION,
    new_tests_smoothed DOUBLE PRECISION,
    new_tests_smoothed_per_thousand DOUBLE PRECISION,
    positive_rate DOUBLE PRECISION,
    tests_per_case DOUBLE PRECISION,
    tests_units TEXT,
    total_vaccinations DOUBLE PRECISION,
    people_vaccinated DOUBLE PRECISION,
    people_fully_vaccinated DOUBLE PRECISION,
    new_vaccinations DOUBLE PRECISION,
    new_vaccinations_smoothed DOUBLE PRECISION,
    total_vaccinations_per_hundred DOUBLE PRECISION,
    people_vaccinated_per_hundred DOUBLE PRECISION,
    people_fully_vaccinated_per_hundred DOUBLE PRECISION,
    new_vaccinations_smoothed_per_million DOUBLE PRECISION,
    stringency_index DOUBLE PRECISION,
    population_density DOUBLE PRECISION,
    median_age DOUBLE PRECISION,
    aged_65_older DOUBLE PRECISION,
    aged_70_older DOUBLE PRECISION,
    gdp_per_capita DOUBLE PRECISION,
    extreme_poverty DOUBLE PRECISION,
    cardiovasc_death_rate DOUBLE PRECISION,
    diabetes_prevalence DOUBLE PRECISION,
    female_smokers DOUBLE PRECISION,
    male_smokers DOUBLE PRECISION,
    handwashing_facilities DOUBLE PRECISION,
    hospital_beds_per_thousand DOUBLE PRECISION,
    life_expectancy DOUBLE PRECISION,
    human_development_index DOUBLE PRECISION
);

-- Data Managment 

SELECT *
FROM covid_deaths
ORDER BY 3,4

SELECT *
FROM covid_vaccinations
ORDER BY 3,4

SELECT *
FROM covid_deaths
WHERE continent is not null 
ORDER BY 3,4


-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
WHERE continent is not null 
ORDER BY 1,2


-- Total Cases vs Total Deaths

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covid_deaths
WHERE location = 'India'
AND continent is not null 
ORDER BY 1,2


-- Total Cases vs Population

SELECT location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM covid_deaths
ORDER BY 1,2


-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM covid_deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
From covid_deaths
WHERE continent is not null 
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Showing contintents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM covid_deaths
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathCount DESC



-- GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM covid_deaths
WHERE continent is not null 
ORDER BY 1,2



-- Total Population vs Vaccinations Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations AS int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM covid_deaths AS dea
JOIN covid_vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3


-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM covid_deaths AS dea
JOIN covid_vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac