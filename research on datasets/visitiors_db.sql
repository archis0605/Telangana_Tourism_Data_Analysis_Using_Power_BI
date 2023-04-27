-- List down the top 5 districts that have the highest number of domestic visitors overall (2016 - 2019)?
select district as top_district, sum(domestic_visitors) as total_dom_visitors
from telengana_tourist_dataset.visitors_db
group by district
order by total_dom_visitors desc
limit 5;

-- List down the bottom 5 districts that have the highest number of domestic visitors overall (2016 - 2019)?
select district as bottom_district, sum(domestic_visitors) as total_dom_visitors
from telengana_tourist_dataset.visitors_db
group by district
order by total_dom_visitors asc
limit 5;

-- List down the top 5 districts that have the highest number of foreign visitors overall (2016 - 2019)?
select district as top_district, sum(foreign_visitors) as total_for_visitors
from telengana_tourist_dataset.visitors_db
group by district
order by total_for_visitors desc
limit 5;

-- List down the bottom 5 districts that have the highest number of foreign visitors overall (2016 - 2019)?
select district as bottom_district, sum(foreign_visitors) as total_for_visitors
from telengana_tourist_dataset.visitors_db
group by district
order by total_for_visitors asc
limit 5;

-- List down the top 3 districts based on compounded annual growth rate (CAGR) of domestic visitors between (2016 - 2019)?
with initial as(
		select district , sum(visitors) as first_year
		from dvisitors_2016_2019
		where year = 2016
		group by district),
final as( 
		select district , sum(visitors) as last_year
		from dvisitors_2016_2019
		where year = 2019
		group by district) 
select i.district as top_district, i.first_year, f.last_year, round((power((f.last_year/i.first_year),1/3)-1)*100,2) as CAGR
from final f
join initial i
on f.district = i.district
order by CAGR desc limit 3;

-- List down the bottom 3 districts based on compounded annual growth rate (CAGR) of domestic visitors between (2016 - 2019)?
with initial as(
		select district , sum(visitors) as first_year
		from dvisitors_2016_2019
		where year = 2016
		group by district),
final as( 
		select district , sum(visitors) as last_year
		from dvisitors_2016_2019
		where year = 2019
		group by district) 
select i.district as bottom_district, i.first_year, f.last_year, round((power((f.last_year/i.first_year),1/3)-1)*100,2) as CAGR
from final f
join initial i
on f.district = i.district
having CAGR is not null
order by CAGR asc limit 3;

-- List down the top 3 districts based on compounded annual growth rate (CAGR) of foreign visitors between (2016 - 2019)?
with initial as(
		select district , sum(visitors) as first_year
		from fvisitors_2016_2019
		where year = 2016
		group by district),
final as( 
		select district , sum(visitors) as last_year
		from fvisitors_2016_2019
		where year = 2019
		group by district) 
select i.district as top_district,i.first_year,f.last_year, round((power((f.last_year/i.first_year),1/3)-1)*100,2) as CAGR
from final f
join initial i
on f.district = i.district
order by CAGR desc limit 3;

-- List down the bottom 3 districts based on compounded annual growth rate (CAGR) of foreign visitors between (2016 - 2019)?
with initial as(
		select district , sum(visitors) as first_year
		from fvisitors_2016_2019
		where year = 2016
		group by district),
final as( 
		select district , sum(visitors) as last_year
		from fvisitors_2016_2019
		where year = 2019
		group by district) 
select i.district as bottom_district,i.first_year,f.last_year, round((power((f.last_year/i.first_year),1/3)-1)*100,2) as CAGR
from final f
join initial i
on f.district = i.district
having CAGR is not null
order by CAGR asc limit 3;


-- What are the peak and low season months for Hyderabad based on the data from 2016 to 2019 for Hyderabad district?
-- Peak Month
select month as peak_month, sum(visitors) as total				/*for domestic visitors*/
from telengana_tourist_dataset.dvisitors_2016_2019
where district = "Hyderabad"
group by month
order by total desc
limit 3;

-- Low Month
select month as low_month, sum(visitors) as total				/*for domestic visitors*/
from telengana_tourist_dataset.dvisitors_2016_2019
where district = "Hyderabad"
group by month
order by total asc
limit 3;

-- Peak Month
select month as peak_month, sum(visitors) as total				/*for foreign visitors*/
from telengana_tourist_dataset.fvisitors_2016_2019
where district = "Hyderabad"
group by month
order by total desc
limit 3;

-- Low Month
select month as low_month, sum(visitors) as total				/*for foreign visitors*/
from telengana_tourist_dataset.fvisitors_2016_2019
where district = "Hyderabad"
group by month
order by total asc
limit 3;

/* Show the top & bottom 3 districts with high percentage of foreign to domestics tourist ratio? */
-- top 3 district foreign to domestic tourist ratio
with
	cte1 as (
		select district, sum(domestic_visitors) as d_total
		from telengana_tourist_dataset.visitors_db
		group by district
		order by d_total desc),
	cte2 as (
		select district, sum(foreign_visitors) as f_total
		from telengana_tourist_dataset.visitors_db
		group by district
		order by f_total desc)
select d.district as top_district, d.d_total, f.f_total, ((f.f_total/d.d_total)*100) as foreign_to_domestic_ratio
from cte1 d
join cte2 f
on d.district = f.district
order by foreign_to_domestic_ratio desc
limit 3;

-- bottom 3 district domestic to foreign tourist ratio
with
	cte1 as (
		select district, sum(domestic_visitors) as d_total
		from telengana_tourist_dataset.visitors_db
		group by district
		order by d_total desc),
	cte2 as (
		select district, sum(foreign_visitors) as f_total
		from telengana_tourist_dataset.visitors_db
		group by district
		order by f_total desc)
select d.district as bottom_district, d.d_total, f.f_total, ((f.f_total/d.d_total)*100) as foreign_to_domestic_ratio
from cte1 d
join cte2 f
on d.district = f.district
order by foreign_to_domestic_ratio desc
limit 11, 3;

/* List the top & bottom 5 districts based on ‘population to tourist footfall ratio*’ ratio in 2019?*/
 
/*As per demographics table, resident population 2011 = 35828292
As per the adhar statistic, resident population 2022 = 38472769
increase in population = 38472769-35828292 = 2644477
growth rate = 2644477 / 35828292 = 0.073809
growth rate per year = 0.073809 / 11 = 0.007
growth rate percentage = 0.007 * 100 = 0.7
(resident population 2011) * 0.007 = yearly growth => 4963
*/

-- Top 3 District
with cte as(
select district, sum(total_visitors) as visitors
from visitors_db
where year = 2019
group by district
)
select d.district as top_district, c.visitors, d.resident_population_2019, (c.visitors/d.resident_population_2019) as pf_ratio
from demographics d
join cte c
on c.district = d.district
order by pf_ratio desc
limit 5;


-- Bottom 5 District
with cte as(
select district, sum(total_visitors) as visitors
from visitors_db
where year = 2019
group by district
)
select d.district as bottom_district, c.visitors, d.resident_population_2019, (c.visitors/d.resident_population_2019) as pf_ratio
from demographics d
join cte c
on c.district = d.district
order by pf_ratio asc
limit 3;

/* What will be the projected number of domestic and foreign tourists in hyderabad in 2025 based 
on the growth rate from previous years? */

-- Projected number of domestic tourist in 2025
 with cte as(
  select district,
sum(case when year = 2016 Then visitors else 0 End) as visitors_2016 , 
sum(case when year = 2019 Then visitors else 0 End) as visitors_2019	
from telengana_tourist_dataset.dvisitors_2016_2019
group by district 
having district ="Hyderabad"
),
cte2 as(
 select visitors_2019 as dom_visitors_2019,(power((visitors_2019/visitors_2016),(1/3))-1)  as CAGR from cte   #CAGR -0.16
)
select dom_visitors_2019 , round(dom_visitors_2019*power((1-0.16),6)) as dom_visitors_2025
from cte2;   

-- Projected number of foreign tourists in 2025
with cte as(
  select district,
sum(case when year = 2016 Then visitors else 0 End) as visitors_2016 , 
sum(case when year = 2019 Then visitors else 0 End) as visitors_2019	
from telengana_tourist_dataset.fvisitors_2016_2019
group by district 
having district ="Hyderabad"
),
cte2 as(
 select visitors_2019 as for_visitors_2019,(power((visitors_2019/visitors_2016),(1/3))-1)  as CAGR from cte   #CAGR -0.25
)
select for_visitors_2019 , round(for_visitors_2019*power((1-0.25),6)) as for_visitors_2025
from cte2;   

/* Estimate the projected revenue for Hyderabad in 2025 based on average spend per tourist (approximate data) 
tourist				average revenue
Foreign Tourist		5600.00
Domestic Tourist	1200.00 */

-- Projected Revenue for number of domestic tourist in 2025
with cte as(
  select district,
sum(case when year = 2016 Then visitors else 0 End) as visitors_2016 , 
sum(case when year = 2019 Then visitors else 0 End) as visitors_2019	
from telengana_tourist_dataset.dvisitors_2016_2019
group by district 
having district ="Hyderabad"
),
cte2 as(
 select visitors_2019 as dom_visitors_2019,(power((visitors_2019/visitors_2016),(1/3))-1)  as CAGR from cte   #CAGR -0.16
)
select (dom_visitors_2019 * 1200) as rev_dom_visitors_2019, (round(dom_visitors_2019*power((1-0.16),6)) * 1200) as rev_dom_visitors_2025
from cte2;   

-- Projected number of foreign tourists in 2025
with cte as(
  select district,
sum(case when year = 2016 Then visitors else 0 End) as visitors_2016 , 
sum(case when year = 2019 Then visitors else 0 End) as visitors_2019	
from telengana_tourist_dataset.fvisitors_2016_2019
group by district 
having district ="Hyderabad"
),
cte2 as(
 select visitors_2019 as for_visitors_2019,(power((visitors_2019/visitors_2016),(1/3))-1)  as CAGR from cte   #CAGR -0.25
)
select (for_visitors_2019 * 5600) as rev_for_visitors_2019, (round(for_visitors_2019*power((1-0.25),6)) * 5600) as rev_for_visitors_2025
from cte2; 




