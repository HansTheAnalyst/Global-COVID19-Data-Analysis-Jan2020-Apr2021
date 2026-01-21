/*Total Cases vs Total Deaths
Shows probability of dying if you have COVID in your country */
SELECT Location, Date, total_cases, total_deaths, (1.0 * total_deaths) /  NULLIF(total_cases,0) * 100 as DeathPercentage
FROM CovidDeaths
WHERE Location LIKE ('%Philippines%')
ORDER by 1,2

/*Total cases vs Total Population
Shows what percentage of  the population got COVID */
SELECT Location, Date, population, total_cases,	1.0 * NULLIF(total_cases,0) / population * 100 as PercentPopulationInfected
FROM CovidDeaths
WHERE Location LIKE '%States%'

/*Countries with highest infection rate compared to population*/
SELECT Location, Population, MAX(total_cases) as TotalCases, MAX(1.0 * total_cases/population) * 100 as InfectedPercentagePopulation
FROM CovidDeaths
WHERE Continent is not null
GROUP BY Location, Population
ORDER BY InfectedPercentagePopulation DESC

/*Countries with Highest Death Count per Population*/
SELECT location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE Continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC

/*Continents and Global Regions with Highest Total COVID Death Count*/
SELECT location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent is null 
GROUP BY location
ORDER BY TotalDeathCount Desc

/*Countries with Highest Total COVID Death Count in ASIA*/
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent = 'Asia'
GROUP BY Location
ORDER By TotalDeathCount Desc

/*Countries with Highest Total COVID Death Count in North America*/
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent = 'North America'
GROUP BY Location
ORDER By TotalDeathCount Desc

/*Countries with Highest Total COVID Death Count in South America*/
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent = 'South America'
GROUP BY Location
ORDER By TotalDeathCount Desc

/*Countries with Highest Total COVID Death Count in South America*/
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent = 'South America'
GROUP BY Location
ORDER By TotalDeathCount Desc

/*Countries with Highest Total COVID Death Count in Africa*/
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent = 'Africa'
GROUP BY Location
ORDER By TotalDeathCount Desc

/*Countries with Highest Total COVID Death Count in Ocenia*/
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent = 'Oceania'
GROUP BY Location
ORDER By TotalDeathCount Desc

/*Countries with Highest Total COVID Death Count in Europe*/
SELECT Location, MAX(total_deaths) as TotalDeathCount
FROM CovidDeaths
WHERE continent = 'Europe'
GROUP BY Location
ORDER By TotalDeathCount Desc

/*Global Numbers*/
/*Total Death Percentage around the World*/
  
SELECT SUM(CAST(new_cases as INT)) as TotalCases, SUM(CAST(new_deaths as INT)) as TotalDeaths,
  1.0 * SUM(CAST(new_deaths as INT)) / SUM(CAST(new_cases as INT)) * 100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null

/* Comparing total population with cumulative vaccinations over time */
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
SUM(CAST(new_vaccinations as INT)) OVER (PARTITION BY (dea.location) ORDER BY dea.location, dea.date) as CumulativeVaccinations
FROM CovidDeaths as dea
JOIN CovidVaccinations as vac
ON dea.location =  vac.location
and dea.date = vac.date
WHERE dea.continent is not null and dea.location = 'Canada'
ORDER BY 2,3 


/* Percentage of population vaccinated over time using CTE*/

WITH CTE_PopulationVaccinations (Continent, Location, Date, Population, New_Vaccinations, CumulativeVaccinations)
as
(SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
SUM(CAST(new_vaccinations as INT)) OVER (PARTITION BY (dea.location) ORDER BY dea.location, dea.date) as CumulativeVaccinations
FROM CovidDeaths as dea
JOIN CovidVaccinations as vac
ON dea.location =  vac.location
and dea.date = vac.date
WHERE dea.continent is not null)

SELECT *, (1.0 * CumulativeVaccinations / Population) * 100 as VaccinationPercentage
FROM CTE_PopulationVaccinations



/* Percentage of population vaccinated over time using temp table*/
CREATE table #tempPopulationVaccinations(
Continent varchar(50),
Location varchar(100),
Date date,
Population bigint,
New_Vaccinations bigint,
CumulativeVaccinations bigint)

INSERT INTO #tempPopulationVaccinations
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
SUM(CAST(new_vaccinations as INT)) OVER (PARTITION BY (dea.location) ORDER BY dea.location, dea.date) as CumulativeVaccinations
FROM CovidDeaths as dea
JOIN CovidVaccinations as vac
ON dea.location =  vac.location
and dea.date = vac.date
WHERE dea.continent is not null

SELECT *, (1.0 * CumulativeVaccinations / Population) * 100 as VaccinationPercentage
FROM #tempPopulationVaccinations



