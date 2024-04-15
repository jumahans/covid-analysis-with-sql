
select *
from table_one
order by 3,4

select *
from table_two
order by 3,4

select continent, location, date, total_cases, new_cases, total_deaths
from covid_database.dbo.table_two
order by 1,2

--looking at total cases vs total deaths
select continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentage_of_deaths 
from covid_database.dbo.table_two
where location like '%stan%'
order by date

--total cases vs new cases
with cte as (
select  continent, location, date, total_cases, new_cases, total_deaths, (new_cases/total_cases)*100 as total_cases_percantage
from covid_database.dbo.table_two)

select *
from cte
where total_cases_percantage = 100
order by date

--countries with highest infection rate

select continent, location, date, total_cases, max(total_cases) as number_of_infected_people, total_deaths
from covid_database.dbo.table_two
group by continent, location, date, total_cases, total_deaths
order by number_of_infected_people desc

--highest number of deaths 
select continent, location, date,total_deaths, max(cast(total_deaths as int)) as maximum_deaths
from covid_database.dbo.table_two
where continent is not null
group by continent, location, date, total_deaths
order by maximum_deaths desc

select continent, 
count(continent) over (partition by continent) as number_of_countries
from covid_database.dbo.table_two

select continent, count(continent) as number_of_countries
from covid_database.dbo.table_two
group by continent

select count(continent) as number_of_countries
from covid_database.dbo.table_two

--showing the continents with the highest death count.
select continent, max(total_deaths) as highest_death_count
from covid_database.dbo.table_two
group by continent
order by highest_death_count 

--global numbers per day 

select date, count(date), sum(total_cases) as number_of_infected_people, sum(total_deaths) as number_of_dead_people
from covid_database.dbo.table_two
group by  date
order by date 

--joined tables
select continent, location, date, total_cases, max(total_cases) as number_of_infected_people, total_deaths
from covid_database.dbo.table_one as one
inner join covid_database.dbo.table_two as two
	on one.total_cases_per_million = two.total_cases_per_million
	and one.new_cases_per_million = two.new_cases_per_million
group by continent, location, date, total_cases, total_deaths
order by number_of_infected_people desc

-- temp table
create table #temporary_covid_table
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
total_cases float,
number_of_infected_people numeric,
total_death numeric
)

insert into #temporary_covid_table
select continent, location, date, total_cases, max(total_cases) as number_of_infected_people, total_deaths
from covid_database.dbo.table_one as one
inner join covid_database.dbo.table_two as two
	on one.total_cases_per_million = two.total_cases_per_million
	and one.new_cases_per_million = two.new_cases_per_million
group by continent, location, date, total_cases, total_deaths
order by number_of_infected_people desc

select *
from #temporary_covid_table




--creating views to store dat or later visualisations

create view temporary_covid_table as 
select continent, location, date, total_cases, max(total_cases) as number_of_infected_people, total_deaths
from covid_database.dbo.table_one as one
inner join covid_database.dbo.table_two as two
	on one.total_cases_per_million = two.total_cases_per_million
	and one.new_cases_per_million = two.new_cases_per_million
group by continent, location, date, total_cases, total_deaths
--order by number_of_infected_people desc