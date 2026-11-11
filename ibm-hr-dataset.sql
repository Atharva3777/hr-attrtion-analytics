# 1 Count of Employees
select count(*) from hr_attrition_raw;

# 2 Duplicate records 
select EmployeeNumber, count(*) from hr_attrition_raw
group by EmployeeNumber
having count(*) > 1;  

# 3 Missing value of records
select count(*) from hr_attrition_raw
where Attrition is null or Department is null or MonthlyIncome is null; 

# 4 Columns with only one value (For Removal)
select count(distinct EmployeeCount) as employee_count_values,
count(distinct Over18) as over18_value,
count(distinct StandardHours) as stardard_hours_values
from hr_attrition_raw;

# 5 check if the attrtion column is has yes / no values
select attrition, count(*) from hr_attrition_raw
group by attrition;

# 6 Creating a view 
create view vw_hr_clean as
select 
	EmployeeNumber as employee_id,
    Age,
    CASE
		when age < 30 then 'Under 30'
        when age between 30 and 39 then '30-39'
        when age between 40 and 49 then '40-49'
        else '50+'
	end as age_group,
    Gender,
    MaritalStatus,
    Department,
    JobRole,
    JobLevel,
    BusinessTravel,
    OverTime,
    DistanceFromHome,
    MonthlyIncome,
    case 
		when MonthlyIncome < 3000 then '1. Below 3k'
        when MonthlyIncome < 6000 then '2. 3k-6k '
        when MonthlyIncome < 10000 then '3. 6k-10k'
        else '4. 10k+'
	end as incomeband,
    YearsAtCompany,
    case 
		when YearsAtCompany <= 2 then '0-2yrs'
        when YearsAtCompany <=5 then '3-5yrs'
        when YearsAtCompany <=10 then '6-10yrs'
        else '4. 10+ yrs'
	end as tenureband,
    YearsSinceLastPromotion,
    NumCompaniesWorked,
    case education
		when 1 then 'Below College'
        when 2 then 'College'
        when 3 then 'Bachelor'
        when 4 then 'Master'
        when 5 then 'Doctor'
	end as education_level,
    case JobSatisfaction
		when 1 then 'Low'
        when 2 then 'Medium'
        when 3 then 'High'
        when 4 then 'Very High'
	end as job_satisfaction,
    case WorkLifeBalance
		when 1 then 'Bad'
        when 2 then 'Good'
        when 3 then 'Better'
        when 4 then 'Best'
	end as work_life_balance,
    case EnvironmentSatisfaction
		when 1 then 'low'
        when 2 then 'Medium'
        when 3 then 'High'
        when 4 then 'Very High'
	end as environment_satisfaction,
    PerformanceRating,
    Attrition as attrition,
    case when Attrition = 'Yes' 
    then 1 else 0 end as attrition_flag
from hr_attrition_raw;

select * from vw_hr_clean;

# 7 Analysis queries (sql eda)

select count(*) as total_employees, sum(attrition_flag) as employees_left, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean;

select department, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by department
order by attrition_percentage desc;

select JobRole, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by JobRole
order by attrition_percentage desc;

select OverTime, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by OverTime
order by attrition_percentage desc;

select age_group, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by age_group
order by attrition_percentage desc;

select incomeband, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by incomeband
order by attrition_percentage desc;

select tenureband, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by tenureband
order by attrition_percentage desc;

select MaritalStatus, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by MaritalStatus
order by attrition_percentage desc;

select BusinessTravel, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by BusinessTravel
order by attrition_percentage desc;

select Gender, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by Gender
order by attrition_percentage desc;

select job_satisfaction, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by job_satisfaction
order by attrition_percentage desc;

select work_life_balance, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by work_life_balance
order by attrition_percentage desc;

select YearsSinceLastPromotion, count(*) as total, sum(attrition_flag) as left_count, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by YearsSinceLastPromotion
order by attrition_percentage desc;

# 8 Income based analysis
select attrition, round(avg(MonthlyIncome)) as avg_income, round(avg(YearsAtCompany),1) as avg_tenure, round(avg(Age),1) as avg_age
from vw_hr_clean
group by attrition;

# 9 Overtime satisfaction analysis
select OverTime, job_satisfaction, count(*) as total, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by OverTime, job_satisfaction
order by attrition_percentage desc;

# 10 job roles with above average attrition rate

select JobRole, round(100 * sum(attrition_flag)/count(*),1) as attrition_percentage
from vw_hr_clean
group by JobRole
order by attrition_percentage desc;

SELECT COUNT(*) AS employees, SUM(attrition_flag) AS left_count,
		ROUND(100*SUM(attrition_flag)/COUNT(*),1) AS attrition_pct
FROM vw_hr_clean
WHERE OverTime = 'Yes' AND MaritalStatus = 'Single' AND Age < 30;

select * from vw_hr_clean;






    
         
        










