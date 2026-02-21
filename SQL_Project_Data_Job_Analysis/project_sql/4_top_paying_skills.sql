/*
**Answer: What are the top skills based on salary?** 

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts 
  and helps identify the most financially rewarding skills to acquire or improve.
  */

SELECT
    sd.skills,
    ROUND(AVG(jf.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact AS jf
INNER JOIN
    skills_job_dim AS sjd
    ON jf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    -- Filter for Data Analyst roles
    jf.job_title_short = 'Data Analyst'
    AND jf.job_work_from_home = TRUE
    AND jf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
ORDER BY
    avg_salary DESC
LIMIT 25;
/*
🔎 Overall Trend Summary

Big Data skills pay the most

Cloud & DevOps boost salary

Python ecosystem dominates

Enterprise ML tools are valuable

Basic BI/database skills are baseline

Specialized infrastructure skills command premium
*/