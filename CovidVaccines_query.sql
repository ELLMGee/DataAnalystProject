-- data for total infections and total vaccination 
SELECT * FROM PortfolioProject..CovidDeaths$  dea
Join PortfolioProject..CovidVaccines$  vac
	ON dea.location = vac.location
	and dea.date = vac.date

-- total population that has been vaccinated
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
	SUM(convert(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as TotalofVaccinated, -- total of vaccine added per day
FROM PortfolioProject..CovidDeaths$  dea
Join PortfolioProject..CovidVaccines$  vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- to show the percentage of the vaccinated population using a Temp Table
DROP TABLE IF Exists #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated(
continent nvarchar(255),
locaton nvarchar(255),
date datetime,
population float,
new_vaccinations int,
RollingTotalVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
	   SUM(convert(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingTotalVaccinated
	FROM PortfolioProject..CovidDeaths$  dea
Join PortfolioProject..CovidVaccines$  vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

select *, (RollingTotalVaccinated/population)*100 as VaccinatedPercentage FROM #PercentagePopulationVaccinated 
where RollingTotalVaccinated is not null
order by 2,3

-- OR same problem ^^^ but using a CTE

WITH CTE_PopulationVaccinated (Continent, Location, Date, Population, new_vaccinations, RollingTotalVAccinated)
as (
	SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
	   SUM(convert(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingTotalVaccinated
	FROM PortfolioProject..CovidDeaths$  dea
	Join PortfolioProject..CovidVaccines$  vac
		ON dea.location = vac.location
		and dea.date = vac.date
	Where dea.continent is not null
	)
	select *, (RollingTotalVaccinated/population)*100 as VaccinatedPercentage FROM CTE_PopulationVaccinated 
	where RollingTotalVaccinated is not null
	order by 1,2 

