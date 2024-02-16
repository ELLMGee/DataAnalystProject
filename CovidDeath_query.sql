SELECT * FROM PortfolioProject..CovidDeaths$
Order by 3,4

--looking at the data I'll be using
Select Location, date, total_cases, new_cases, total_deaths, population FROM PortfolioProject..CovidDeaths$
Order by 1,2

--Looking for the percentage of total deaths to total cases ratio in the country Philippines
Select Location, total_cases, total_deaths, (total_deaths/total_cases)*100 as Percentage 
FROM PortfolioProject..CovidDeaths$
where location = 'Philippines'
order by 1,2

--Looking for the percentage of total cases to population ratio in the country Philippines
Select Location, date, total_cases, population, (total_cases/population)*100 as Percentage 
FROM PortfolioProject..CovidDeaths$
where location = 'Philippines'
order by 1,2

--looking for which country has the highest infection rate to popultion ratio
SELECT location, Population, MAX(total_cases) AS total_cases,  MAX((total_cases/population))*100 AS Percentage
FROM PortfolioProject..CovidDeaths$
GROUP BY location, Population
ORDER BY Percentage DESC;

--looking for which country has the highest death rate
SELECT location, MAX(cast(total_deaths as int)) AS total_deathcount
FROM PortfolioProject..CovidDeaths$
where continent is not null
GROUP BY location
ORDER BY total_deathcount DESC;

--looking for which country has the highest death rate
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- countries woth the highest death count per papulation
Select continent, MAX((cast(Total_deaths as int))/population) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--
Select date, SUM(new_cases) as Total_NewCases, SUM(cast(new_deaths as int)) as Total_NewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as TotalDeathPercentage
FROM PortfolioProject..CovidDeaths$
Where continent is not null 
Group by date
Order by 1,2
