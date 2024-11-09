create database bike_features;
use bike_features;
select * from bikes;
select distinct transmission from bikes;
select count(*) from bikes;
select distinct count(*) from bikes;
alter table bikes drop column Myunknowncolumn;
select avg(`highway mileage`) as mean_value from bikes;
alter table bikes drop column `highway mileage`;
alter table bikes drop column bore;

#set sql_safe_updates=0;
select * from bikes;
# standardized by removing units (e.g., "kmpl" and "cc") for consistency.
update bikes set stroke=substring_index(stroke,'m',1);
update bikes set stroke=substring_index(stroke,':',1);
update bikes set stroke=substring_index(stroke,'bs6',1);
update bikes set `city mileage`=substring_index(`city mileage`,'kmpl',1);
update bikes set `city mileage`=substring_index(`city mileage`,'mpl',1);
update bikes set `city mileage`=substring_index(`city mileage`,'mm',1);
update bikes set displacement=substring_index(displacement,'cc',1);
update bikes set displacement=substring_index(displacement,'CC',1);
update bikes set `max torque`=substring_index(`max torque`,'N',1);
# rename necessary columns
alter table bikes change column `city mileage` Mileage varchar(5);
alter table bikes change column `company name` Model_name varchar(50);
alter table bikes change column `starting` start_type varchar(50);
# feature engineering
alter table bikes add column company text;
update bikes set company=substring_index(trim(`variant name`)," ",1);
select * from bikes;

##---------------------------------------------SQL Quries----------------------------------------------------
# -Get all bikes from a specific brand
select * from bikes where company='BMW';
# -Count the number of bikes models per brand:
select company,count(*) as model_count from bikes group by company;
# -Find bike with the highest displacement:
select `variant name`,displacement from bikes order by displacement desc limit 1;
# -Get average mileage for each vehicle type:
select `variant name`,avg(mileage) as avg_mileage from bikes group by `variant name`;
# -List bikes that use Fuel Injection as the fuel system:
select `variant name`,`fuel supply` from bikes where `fuel supply` like '%Fuel Injection';
# -Get bikes that have a self-start feature:
select `Variant Name`,Model_name,Start_type from bikes where start_type like "Se% Only";
# -Find the average price of all motorcycles:
select avg(`On-road prize`) as Avg_price from bikes;
# -Get the model names and prices of motorcycles with a mileage greater than 30:
select * from bikes;
select Model_name,`On-road prize`,mileage from bikes where mileage >30;
# -Find motorcycles that are Sports Bikes :
select `variant Name`,`body Type` from bikes where `body type` like 'SP%';
# -Select all bikes with an engine capacity above 200cc:
select `Variant name`,`engine type`,displacement from bikes where displacement>200;
select * from bikes;
desc bikes;

# - Find the minimum on-road price for each bike variant, ordered by price in ascending order.
select `variant name`,min(`on-road prize`) from bikes group by `variant name` order by min(`on-road prize`) ;
# - Find the top 5 bike companies with the highest average mileage.
select company,avg(mileage) as Avg_mileage from bikes group by company order by avg_mileage desc limit 5;
# - List the company, mileage, gearbox, and cooling system of bikes that have an air-cooled cooling system
select company,mileage,`gear box`,`cooling system` from bikes where `cooling system`='air cooled';

# -------------------------------------Univariate Analysis--------------------------------------------------
# Analyzing the frequency of different Engine Types
select `Engine Type`, COUNT(*) as Frequency from bikes group by `Engine Type` order by Frequency desc;
# Analyze central tendencies and variability for numerical variables such as On-road prize, Displacement and Mileage.
   # On-road prize statistics
select min(`On-road prize`) as Min_Price, max(`On-road prize`) as Max_Price, avg(`On-road prize`) 
as Avg_Price, stddev(`On-road prize`) as StdDev_Price from bikes;
   # Mileage statistics
select min(Mileage) as Min_Mileage, max(Mileage) as Max_Mileage, avg(Mileage) as Avg_Mileage, 
stddev(Mileage) as StdDev_Mileage from bikes;
   # Displacement statistics
select min(Displacement) as Min_Displacement, max(Displacement) as Max_Displacement, avg(Displacement) as Avg_Displacement, 
stddev(Displacement) as StdDev_Displacement from bikes;
# Count of each unique value in Gear Box
select `Gear Box`, count(*) as Count from bikes group by `Gear Box` order by Count desc;
# calculates the range and count of On-road prize by model name.
select `Model_name`, min(`On-road prize`) as Min_Price, max(`On-road prize`) as Max_Price, count(*)
as Model_Count from bikes group by `Model_name` order by Model_Count desc;
#-------------------------------------Bivariate Analysis---------------------------------------------------
# Calculate the price ranges for different Engine Type categories
select `Engine Type`, avg(`On-road prize`) as Avg_Price, min(`On-road prize`) as Min_Price, max(`On-road prize`) as Max_Price
from bikes group by `Engine Type` order by Avg_Price desc;
# Compare the average price of bikes based on the number of gears in the Gear Box
select `Gear Box`, avg(`On-road prize`) as Avg_Price, count(*) as Count
from bikes group by `Gear Box` order by Avg_Price desc;
# Analyze the average and range of On-road prize for each type of Cooling System
select `Cooling System`, avg(`On-road prize`) as Avg_Price, min(`On-road prize`) as Min_Price, max(`On-road prize`) as Max_Price
from bikes group by `Cooling System` order by Avg_Price desc;
# Find the most popular models within each engine type based on the count of records
select `Engine Type`, `Model_name`, count(*) as Model_Count from bikes
group by `Engine Type`, `Model_name` order by `Engine Type`, Model_Count desc;






 