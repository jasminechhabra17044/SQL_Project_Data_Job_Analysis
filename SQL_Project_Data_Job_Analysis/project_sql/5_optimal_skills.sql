/*
**Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
 offering strategic insights for career development in data analysis
*/

WITH skills_demand AS(
    SELECT skills_dim.skill_id,skills_dim.skills, count(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim on JOB_Postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
    WHERE
    -- Filters job titles for 'Data Analyst' roles
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg is NOT NULL
    group by skills_dim.skill_id

    
), average_salary AS (
    SELECT skills_dim.skill_id,skills_dim.skills,ROUND(avg(salary_year_avg),0) as avg_salary

    FROM job_postings_fact
    INNER JOIN skills_job_dim on JOB_Postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
    WHERE
    -- Filters job titles for 'Data Analyst' roles
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg is NOT NULL
    group by skills_dim.skill_id
)


SELECT skills_demand.skill_id,skills_demand.skills,
    demand_count,avg_salary
    from average_salary
    INNER JOIN skills_demand on skills_demand.skill_id =average_salary.skill_id
ORDER BY demand_count DESC , average_salary DESC
LIMIT 25;





--- REWRITING

SELECT skills_dim.skill_id,skills_dim.skills,  count(skills_job_dim.job_id) as demand_count,
        ROUND(avg(salary_year_avg),0) as avg_salary
from job_postings_fact
    INNER JOIN skills_job_dim on JOB_Postings_fact.job_id=skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
WHERE  job_postings_fact.job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg is NOT NULL
    group by skills_dim.skill_id
    HAVING count(skills_job_dim.job_id)>10
ORDER BY demand_count DESC , avg_salary DESC