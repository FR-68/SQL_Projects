select location, date, total_cases, new_cases, total_deaths, population
From [Covid Data Analysis]..COVID_DEATHS$
where continent is not NULL
order by 1,2 

-- Total Cases v/s Total deaths in India
select location, date, total_cases, total_deaths, (total_deaths /total_cases) *100 as Death_percentage
From [Covid Data Analysis]..COVID_DEATHS$
where continent is not NULL
and location like '%india%'
order by 1,2 

-- Total Cases v/s Population in India
select location, date, population, total_cases, (total_cases /population) *100 as Infected_percentage
From [Covid Data Analysis]..COVID_DEATHS$
where location like '%india%' and continent is not NULL
order by 1,2 

-- Countries with Highest infection rate compared to population
select location, population, Max(total_cases) as Highest_Infection_Rate, Max((total_cases /population)) *100 as Infected_percentage
From [Covid Data Analysis]..COVID_DEATHS$
where continent is not NULL
Group by location, population
order by Infected_percentage DESC

-- Death count based on continents
select continent, Max(cast(total_deaths as int)) as Total_death_Rate 
From [Covid Data Analysis]..COVID_DEATHS$
where continent is not NULL
Group by continent
order by Total_death_Rate DESC

-- Countries with highest death count
select location, Max(cast(total_deaths as int)) as Highest_death_Rate 
From [Covid Data Analysis]..COVID_DEATHS$
where continent is not NULL
Group by location
order by Highest_death_Rate DESC


-- Global Numbers
select sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as Deathpercentage 
From [Covid Data Analysis]..COVID_DEATHS$
where continent is not NULL 
-- Group by date
order by 1,2 



-- Total Population v/s vaccinations
Drop Table if exists #Percentage_Pop_Vaccinated
Create Table #Percentage_Pop_Vaccinated
( Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
People_Vaccinated numeric
)

Insert into #Percentage_Pop_Vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as People_Vaccinated
From [Covid Data Analysis]..COVID_DEATHS$ Dea
Join [Covid Data Analysis]..COVID_VACCINES$ Vac
	on dea.location=vac.location
	and dea.date = vac.date
where dea.continent is not null


Select *
FROM Percentage_Pop_Vaccinated

-- Percentage Pop Vaccinated View 
Create View Percentage_Pop_Vaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as People_Vaccinated
From [Covid Data Analysis]..COVID_DEATHS$ Dea
Join [Covid Data Analysis]..COVID_VACCINES$ Vac
	on dea.location=vac.location
	and dea.date = vac.date
where dea.continent is not null