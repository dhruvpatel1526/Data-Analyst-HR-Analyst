# 1. Average attrition rate for all departments

select department, concat(round(avg(total_attrition) * 100,2),"%") as attrition_rate
from hr1
group by department
order by attrition_rate desc;

# 2. Gender based percentage of employees

select gender, concat(count(employeenumber)/50000*100,"%") as Number_of_employees
from hr1
group by gender;

# 3. Average working years for each department

select hr1.department, round(avg(hr2.YearsAtCompany),2) as Average_working_year 
from hr1 join hr2 on hr1.employeenumber=hr2.employee_ID
group by hr1.department
order by Average_working_year ;

# 4. Department wise number of employees

select department, count(*) as Number_of_employees
from hr1
group by department;

# 5. Total number of employees as per educational field

select EducationField, count(*) as Number_of_employees
from hr1
group by EducationField;

# 6. Average hourly rate of male research scientist

select jobrole, gender, avg(hourlyrate) as Hourly_rate
from hr1
where jobrole="Research Scientist" and Gender = "Male"
group by jobrole, gender;


# 7. Job Role wise job satisfaction

select jobrole, avg(jobsatisfaction) as averge_job_satisfaction
from hr1
group by jobrole;

# 8. Year since last promotion and attrition rate

select hr2.YearsSinceLastPromotion, concat(round(avg(hr1.total_attrition)*100,2),"%") as Attrition_rate
from hr2 
join
hr1 on hr2.employee_ID=hr1.employeenumber
group by hr2.YearsSinceLastPromotion
order by hr2.YearsSinceLastPromotion;

# 9. Monthly income wise attrition rate

select hr2.salary_slab, concat(round(avg(hr1.total_attrition)*100,2), "%") as attrition_rate
from hr2
join hr1 on hr2.employee_ID=hr1.employeenumber
group by hr2.salary_slab
order by hr2.salary_slab;

# 10. Job role wise work life banalance

select hr1.JobRole, avg(hr2.WorkLifeBalance) as Average_Worklife_Balance, 
round(stddev(hr2.WorkLifeBalance),2) as Standard_deviation 
from hr1
join hr2 
on hr1.EmployeeNumber=hr2.Employee_ID
group by hr1.JobRole; 

# 11. Monthly New hire wise attrition

select hr2.Year_of_Joining, hr2.Month_of_Joining, count(*) as Total_Joining, 
sum(hr1.total_attrition) as Number_of_attrition,
concat(round((sum(hr1.total_attrition)/count(*)*100),2),"%") as Attrition_Rate
from hr2 
join hr1 on hr2.Employee_ID=hr1.EmployeeNumber
group by hr2.Year_of_Joining, hr2.Month_of_Joining
order by hr2.Year_of_Joining desc, hr2.Month_of_Joining;

 # 12. Checking early attrition, take 1 or less than 1 year as early attrition
 
delimiter //
create function checkearlyattrition(employee_id int)
returns varchar(50)
deterministic
begin
    declare yearincompany int;
    declare attrition_status varchar(50);

    if exists (
            select 1
            from hr2
            join hr1 on hr1.employeenumber = hr2.employee_id
            where hr2.employee_id = employee_id
                and hr1.attrition = 'yes'
            ) then
        select hr2.yearsatcompany into yearincompany
        from hr2
        join hr1 on hr1.employeenumber = hr2.employee_id
        where hr2.employee_id = employee_id;

        if yearincompany <= 1 then
            set attrition_status = 'early attrition';
        else
            set attrition_status = 'normal attrition';
        end if;
    else
        set attrition_status = 'no attrition record found for the given employee';
    end if;

    return attrition_status;
end//
delimiter ;




