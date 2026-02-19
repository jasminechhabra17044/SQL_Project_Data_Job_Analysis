/*
**Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
  providing insights into the most valuable skills for job seekers.
*/

SELECT skills, count(skills_job_dim.job_id) as demand_count
 FROM job_postings_fact
INNER JOIN skills_job_dim on JOB_Postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
WHERE
  -- Filters job titles for 'Data Analyst' roles
  job_postings_fact.job_title_short = 'Data Analyst'
  AND job_work_from_home = TRUE
group by skills
order by demand_count desc
limit 5