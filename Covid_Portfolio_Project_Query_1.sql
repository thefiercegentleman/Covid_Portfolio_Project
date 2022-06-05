/*Select*
From Covid_Deaths
Where continent is not null
order by 3,4;*/

/*Select*
From dbo.Covid_Vaccination
ORDER BY iso_code 
OFFSET  5 ROWS 
FETCH NEXT 5 ROWS ONLY;*/

/*Select location, date, total_cases, new_cases, total_deaths, population
From Covid_Portfolio_DB..Covid_Deaths
Order by 1,2;*/


--Looking at Total Cases vs. Total Deaths

/*Select location, date, total_cases, total_deaths,(total_deaths/total_cases*100) as 'Death_Rate'
From Covid_Portfolio_DB..Covid_Deaths
Where location like '%states%'
Order by 1,2;*/


--Rate of Death is 1.19% on 06/01/2022 in the US

--Shows what percentage of the population got Covid

/*Select location, date, total_cases, population,(total_cases/population*100) as 'Infection_Rate'
From Covid_Portfolio_DB..Covid_Deaths
Where location like '%states%'
Order by 1,2;*/

--25.4% of the population has gotten Covid in the US

--What countries have the higest infection rates?

/*Select location, Max(total_cases) as 'Infection Cases', Max((total_cases/population*100)) as 'Infection_Rate'
From Covid_Deaths
Group by location, population
Order by 3 Desc;*/

-- The United States has the 57th highest Infection Rate

/*Select location, Max(cast(total_deaths as int)) as 'Deaths', Max((total_deaths/total_cases*100)) as 'Death_Rate'
From Covid_Deaths
Where continent is not null
Group by location
Order by 3 Desc ,2 Desc;*/

--Highest Death Rate By Country

/*Select location, Max(cast(total_deaths as int)) as 'Deaths', Max((total_deaths/total_cases*100)) as 'Death_Rate'
From Covid_Deaths
Where continent is not null
Group by location
Order by 3 Desc ,2 Desc;*/

-- Break down By Continent

/*Select continent, Max(cast(total_deaths as int)) as 'Deaths', Max((total_deaths/total_cases*100)) as 'Death_Rate'
From Covid_Deaths
Where continent is not null
Group by continent
Order by 3 Desc ,2 Desc;*/


--Breakdown by Region and Income

/*Select location, Max(cast(total_deaths as int)) as 'Deaths', Max((total_deaths/total_cases*100)) as 'Death_Rate'
From Covid_Deaths
Where continent is  null
Group by location
Order by 3 Desc;*/

--Global Numbers By Date

/*Select date, SUM(new_cases) as 'Total_New_Cases', SUM(cast(total_deaths as int)) as 'Total_New_Deaths', (Sum(cast(new_deaths as decimal))/ Sum(cast(new_cases as decimal)) * 100) as 'New_Death_Rate'
From Covid_Deaths
Where continent is not null
Group by date 
order by 1,2*/
-- Total Populations in relation to vaccinations

/*Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(decimal,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.Date)/2 as 'Sum_Vaccinations', Sum(Convert(decimal,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.Date)/2/dea.population*100 As 'Percent_Vaccinated'
From Covid_Portfolio_DB..Covid_Deaths dea
Join Covid_Portfolio_DB..Covid_Vaccination vac On
dea.location = vac.location and dea.date = vac.date
where  dea.continent is not null and dea.location like  '%states%'--Second statement is for finding locations
order by 2,3;*/


-- Creating View to store data for later visualizations
/*Create View test as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(decimal,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.Date)/2 as 'Sum_Vaccinations', Sum(Convert(decimal,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.Date)/2/dea.population*100 As 'Percent_Vaccinated'
From Covid_Portfolio_DB..Covid_Deaths dea
Join Covid_Portfolio_DB..Covid_Vaccination vac On
dea.location = vac.location and dea.date = vac.date*/

/*Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(decimal,new_vaccinations)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Covid_Portfolio_DB..Covid_Deaths dea
Join Covid_Portfolio_DB..Covid_Vaccination vac On
dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null and dea.location like '%states%'

Select*, (RollingPeopleVaccinated/Population) *100
From #PercentPopulationVaccinated*/

/*Create view Percent_Pop_Vaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(decimal,new_vaccinations)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Covid_Portfolio_DB..Covid_Deaths dea
Join Covid_Portfolio_DB..Covid_Vaccination vac On
dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null and dea.location like '%states%'*/
