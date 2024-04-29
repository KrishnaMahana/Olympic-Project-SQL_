


--1 How  many olympics games have been held?

select count(distinct(Games)) total_gmaes from Portfolio_project..[ athlete_events]

--2 list down all olympics game held so far.

select YEAR,season,city from [ athlete_events]

--3 total number of nations who participated in each olympics game


select games,count(noc) total_countries from [ athlete_events]
group by games
order by games

-- highest and lowest no of countries participation in olympi

with all_countries as(

select games,nr.region from [ athlete_events] ae
join noc_regions nr
on ae.noc=nr.noc  
group by games,nr.region
), countries as(
select games, count(1)total_countries from all_countries
group by games
)
select distinct
CONCAT(first_value(games) over(order by total_countries),
'-',
first_value(total_countries) over(order by total_countries)) lowest_countries,

concat(first_value(games) over( order by total_countries desc),
'-',
FIRST_VALUE(total_countries) over(order by total_countries desc)) hiest_countries
 
 from countries
 order by 1




--which nation has participated in all of the olympic games?


with totl_countries as(
select count(distinct(games))total_game from [ athlete_events]
),

country as
(
select games, nr.region as  country
from [ athlete_events] ae
join noc_regions nr
on ae.noc = nr.noc
group by games,nr.region
 )
  ,
particpated_countries as
(
select country,count(country) as total_particpated_games 
from country
group by country
)
select * from particpated_countries 
where total_particpated_games = 51;



-- identify the sport which was played in all summer olympics


with t1 as
(
select count(distinct (games))total_games from  athlete_events
where Season = 'summer'
), t2 as
(

select distinct(games), sport from [ athlete_events]
where Season = 'summer'
),
t3 as
(
select sport,count(sport) no_games from t2
group by Sport
) select * from t1
join t3
on t1.total_games = t3.no_games


--which sports where just palyed only once in the olympics


with t1 as 
(
select distinct games, sport from [ athlete_events]
),t2 as
(
select sport,count(games)on_games from t1

group by sport

) select t1.*,t2.on_games from t1
join t2
on t1.sport = t2.sport
where on_games = 1
order by Games

-- total no of sport played in each olympic games


with t1 as (
select  distinct games,sport from [ athlete_events]
) select games,count(1)no_game from t1
group by games
order by no_game desc

-- oldest athletes to win a gold medal



with t1 as (
select name,age,sport,season,city,medal from [ athlete_events]
),t2 as (
select *,
 RANK() over ( order by age desc)rk
from t1
where medal= 'gold'
) select * from t2
where rk= 1

-- the ration of male and female athletes participated in all olympic games



select sex, count(sex)cnt from [ athlete_events]
group by sex



--top 5 athletes who have won the most gold medals


with t1 as 
(
select name, games,noc, sport,Medal from [ athlete_events]
), t2 as 
(
select name,count(name)total_gold from t1
	where medal = 'gold'
	group by name
	
) , t3 as
(
select *,DENSE_RANK() over(order by total_gold desc) as rk from t2
) select distinct  t1.name,sport,  total_gold
from t1
join t3
on t1.name = t3.name
where medal = 'gold' 
AND rk <= 5
order by total_gold desc



--the top 5 most who have won the most medals (gold,silver,bronze)


with t1 as 
(
select name,Sport,Medal from [ athlete_events]
where Medal in  ('gold','silver','bronze')  
), t2 as 
(
select name,count(1)total_medal from t1 
group by name

),t3 as 
(
select *, DENSE_RANK() over(order by total_medal desc) rk from t2
) 
select distinct t1.name, total_medal from t1
join t3
on t1.name = t3.name
where rk <= 5
order by total_medal desc


--total gold, silver & bronze medals won by each country
with t1 as 
(select region, medal from [ athlete_events] ae
join noc_regions nr
on ae.NOC = nr.NOC
),gold as 
(
select region,medal, count(medal)Gold from t1
where medal = 'gold' 
group by region,medal 
),silver as
(

select region , medal , count(medal)Silver  from t1
where medal = 'silver'
group by region, Medal
),bronze as
(
select region, medal ,count(medal)Bronze  from t1
where medal = 'bronze'
group by region,medal 
)

select g.region as Country, Gold,Silver, Bronze from gold g
join silver s
on g.region =s.region
join bronze b
on s.region = b.region
order by gold desc






--top 5 most successfull countries in olypics
 
 with t1 as 
 (

select region,count(region)total_medal
from noc_regions nr
join [ athlete_events] ae
on nr.NOC= ae.NOC
where Medal in ('gold','silver' ,'bronze')
group by region 

) ,t2 as
(select *,DENSE_RANK() over (order by total_medal desc) rk from t1)

select t1.region, t1.total_medal, rk from t1 join t2
on t1.region = t2.region
where rk <= 5
order by t1.total_medal desc


--Country have never won gold medal but have won silver/bronze medals 
with t1 as 

(
select region,Medal  from [ athlete_events] ae
join noc_regions nr
on ae.noc = nr.noc


), t2 as 
(
select region,medal  from t1
where medal in ('silver', 'bronze') and medal != 'gold'
), silver as
(
select region, count (region) silver  from t2
where medal = 'silver' and Medal <> 'gold' and medal <> 'bronze '
group by region 
) ,bronze as 
(
select region, count(region) bronze from t2
where medal = 'bronze' and  medal <> 'gold' and medal <> 'silver'
group by region
)
select
distinct t.region,Medal as gold,silver,bronze from t1 t
right  join silver  s
on t.region = s.region
right join bronze b
on t.region = b.region
where t.medal = 'gold'
order by silver desc

        
	
-- which sport india has won highest medals

with t1 as 
(
select  nr.region, Sport from [ athlete_events] ae
join noc_regions nr
on ae.NOC = nr.NOC
where region = 'india'
)
select region, (count region) from t1

