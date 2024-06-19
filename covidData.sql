select * from project..CovidDeaths order by 3,4

select location, date,total_cases ,new_cases,total_deaths,population from project..CovidDeaths order by 1,2


-- Looking at total vs total deaths
--Shows likelihood of dying if you contact covid in your country

select location, date,total_cases ,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage from project..CovidDeaths
where location like '%india%'
order by 1,2

--looking at the total cases vs population
--Shows what percentage of population got covid
select location, date,population,total_cases, (total_cases/population)*100 as DeathPercentage from project..CovidDeaths
order by 1,2

--Looking  at Countries  with Highest Infection Rate compared to Population

select location, population, MAX(total_cases) as HightestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
from project..CovidDeaths Group by Location ,Population 
order by PercentPopulationInfected DESC


--Showing highest Death Count per Population
select location, MAX(total_cases) as TotalDeathsCount from project..CovidDeaths 
Group by Location
order by TotalDeathsCount desc

--Showing continent with highest death count per population
--breaking down by continent
select continent, MAX(cast(total_deaths as int)) as TotalDeathsCount from project..CovidDeaths where continent is not null
Group by continent
order by TotalDeathsCount desc


--GLOBAL NUMBERS
select date,SUM(new_cases ) as totalcases, Sum (cast(new_deaths as int))as totaldeaths,SUM(cast(New_deaths as int ))/SUM(New_Cases)*100 as DeathsPercentage
from project..CovidDeaths
where continent is not null group by date
order by 1,2


--Looking at total population vs vaccination 


--USE CTE

With PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent ,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) Over(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from project..CovidDeaths dea 
Join project..covidvaccination vac 
   on dea.location = vac.location 
   and dea.date = vac.date 
where dea.continent is not null
-- order by 2,3
)
select*,(RollingPeopleVaccinated/Population)*100 from PopvsVac



--temp table

DROP Table if exists #percentPopulationVaccinated
create table #percentPopulationVaccinated
( Continent nvarchar(255), Location nvarchar(300),Date datetime,Population numeric,New_vaccination numeric, RollingpeopleVaccinated numeric)

insert into  #percentPopulationVaccinated
select dea.continent ,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) Over(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from project..CovidDeaths dea 
Join project..covidvaccination vac 
   on dea.location = vac.location 
   and dea.date = vac.date 
--where dea.continent is not null

select*,(RollingPeopleVaccinated/Population)*100 from #percentPopulationVaccinated

--creating view to store data for visualisations
 Create view percentPopulationVaccinated as
select dea.continent ,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) Over(Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from project..CovidDeaths dea 
Join project..covidvaccination vac 
   on dea.location = vac.location 
   and dea.date = vac.date 
where dea.continent is not null

select * from percentPopulationVaccinated

