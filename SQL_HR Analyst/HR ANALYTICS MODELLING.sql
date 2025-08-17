# Creating age group column

alter table hr1
add column age_group varchar(20);
SET SQL_SAFE_UPDATES = 0;
update hr1
set age_group=case
				when ï»¿Age<=30 then "18-30"
                when ï»¿Age<=40 then "31-40"
                when ï»¿Age<=50 then "40-50"
                else "50+"
			end;
            
#Creating attrition binary column

alter table hr1
add column total_attrition int;

update hr1
set total_attrition=case
					when attrition = "Yes" then 1
                    else 0
				end;
                
#Salary category creation

alter table hr2
add column salary_slab varchar(50);

update hr2
set salary_slab = case
					when MonthlyIncome<=10000 then "0-10k"
                    when MonthlyIncome<=20000 then "10-20k"
                    when MonthlyIncome<=30000 then "20-30k"
                    when MonthlyIncome<=40000 then "30-40k"
                    else "40-51k"
				end;
                
