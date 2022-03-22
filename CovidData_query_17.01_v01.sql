--Table Name : CovidDeaths
SELECT * 
FROM Portfolio..CovidDeaths
WHERE continent is not NULL
ORDER BY 3,4

-- Table Name: CovidVaccine
--SELECT * 
--FROM Portfolio..CovidVaccine
--ORDER BY 3,4;



--Critical data fields that are to be used
SELECT Location, date, total_cases, new_cases, total_deaths, population 
FROM Portfolio..CovidDeaths 
WHERE continent is not NULL
ORDER BY 1,2



--Total Death/Cases in >> INDIA <<
SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as death_Rate 
FROM Portfolio..CovidDeaths 
WHERE location = 'India' and continent is not NULL
ORDER BY 1,2;


--Total Cases Vs Population
--Shows the %age of population that got affected
SELECT Location, date, total_cases,population, (total_cases/population)*100 as infection_Rate 
FROM Portfolio..CovidDeaths 
WHERE location = 'India'
ORDER BY 1,2;


--Countries with the highest infection_rate
SELECT Location,population,MAX(total_cases) as Total_Infection_Count, MAX((total_cases/population)) *100 as Infection_Rate 
FROM Portfolio..CovidDeaths 
WHERE continent is not NULL
GROUP BY Location,population 
ORDER BY Infection_Rate DESC;


--Countries with the highest death_count
SELECT Location,MAX(cast(total_deaths as int)) as Total_death_Count
FROM Portfolio..CovidDeaths 
WHERE continent is not NULL
GROUP BY Location
ORDER BY Total_death_Count DESC;


--Continenets with the highest death_count
SELECT location,MAX(cast(total_deaths as int)) as Total_death_Count
FROM Portfolio..CovidDeaths 
WHERE continent is not NULL
GROUP BY location
ORDER BY Total_death_Count DESC;



--GLOBAL NUMBERS = DAILY GLOBAL CASES
SELECT date, SUM(new_cases) as daily_new_cases,SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage_Global
FROM Portfolio..CovidDeaths 
WHERE continent is not NULL
GROUP BY date
ORDER BY 1,2



---------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


--Total amount of vaccinated population
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location Order By dea.location,dea.date) as RollingVaccines
 --,(RollingVaccines/population)*100 
FROM Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccine vac
	on dea.location = vac.location and dea.date =vac.date
WHERE dea.continent is not NULL
ORDER BY 2,3;



--CTE USAGE:

WITH PopulvsVacc (Continent, Location, date, Population, new_vaccinations, RollingVaccines)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location Order By dea.location,dea.date) as RollingVaccines

FROM Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccine vac
	on dea.location = vac.location and dea.date =vac.date
WHERE dea.continent is not NULL

)
SELECT *, (RollingVaccines/Population)*100 as TotalVaccinated FROM PopulvsVacc



--TEMP TABLE: Creating a temporary table and insterting the necessary data into the table.
