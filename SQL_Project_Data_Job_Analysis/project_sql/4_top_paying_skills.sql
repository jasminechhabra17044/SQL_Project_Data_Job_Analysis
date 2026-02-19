/*
**Answer: What are the top skills based on salary?** 

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts 
  and helps identify the most financially rewarding skills to acquire or improve.
  */

SELECT skills,ROUND(avg(salary_year_avg),0) as avg_salary

 FROM job_postings_fact
INNER JOIN skills_job_dim on JOB_Postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
WHERE
  -- Filters job titles for 'Data Analyst' roles
  job_postings_fact.job_title_short = 'Data Analyst'
 AND job_work_from_home = TRUE
 AND salary_year_avg is NOT NULL
group by skills
order by avg_salary desc
limit 25 

/*
🔎 Overall Trend Summary

Big Data skills pay the most

Cloud & DevOps boost salary

Python ecosystem dominates

Enterprise ML tools are valuable

Basic BI/database skills are baseline

Specialized infrastructure skills command premium
*/