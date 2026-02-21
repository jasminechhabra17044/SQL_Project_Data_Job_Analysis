# Introduction
Welcome to my SQL Portfolio Project, where I analyze trends within the data job market, with a particular focus on data analyst roles. Through this project, I explore top-paying positions, the most in-demand technical skills, and where high demand intersects with high salary in the field of data analytics.

You can explore the full set of SQL queries and analysis here: [project_sql forlder](/SQL_Project_Data_Job_Analysis/project_sql/)

# Background
The motivation behind this project is to understand the different trends and requirements for the data analyst job market.

The data from this analysis is from [Luke Barousse’s SQL Course](https://lukebarousse.notion.site/SQL-for-Data-Analytics-8d98ec621e9c4457a999a61afb6b6881) which ijcludes the details about different job positios and their salaries, locations and sills.

The questions that I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?

2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?

# Tools I Used
In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.
- **Git and GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title LIKE '%Data Analyst%'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

```

![top_paying_roles](SQL_Project_Data_Job_Analysis\assets\output.png)

*The chart shows that aside from one extreme outlier ($650K), top-paying data analyst roles cluster tightly between roughly $180K and $230K, mostly at senior and principal levels, generated using ChatGPT*

### 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```SQL
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title LIKE '%Data Analyst%'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

- PySpark dominates — big data processing skills command the highest salaries.

- Cloud + DevOps tools (GCP, Kubernetes, GitLab, Jenkins) significantly increase earning potential.

- AI/ML platforms (DataRobot, Watson) are linked to higher compensation.

- Python tools (Pandas, NumPy, Jupyter) are valuable but more “baseline” than premium.

- Modern databases (Couchbase, Elasticsearch) boost pay more than traditional SQL alone.
- Overall trend: Engineering + scalable data skills pay more than pure analysis skills.


| Job ID  | Job Title                                           | Company                                  | Location  | Schedule  | Avg Salary (USD) | Posted Date |
|---------|----------------------------------------------------|-------------------------------------------|-----------|-----------|------------------|------------|
| 226942  | Data Analyst                                       | Mantys                                    | Anywhere  | Full-time | $650,000         | 2023-02-20 |
| 99305   | Data Analyst, Marketing                            | Pinterest Job Advertisements              | Anywhere  | Full-time | $232,423         | 2023-12-05 |
| 1021647 | Data Analyst (Hybrid/Remote)                       | Uclahealthcareers                         | Anywhere  | Full-time | $217,000         | 2023-01-17 |
| 168310  | Principal Data Analyst (Remote)                    | SmartAsset                                | Anywhere  | Full-time | $205,000         | 2023-08-09 |
| 731368  | Director, Data Analyst - HYBRID                    | Inclusively                               | Anywhere  | Full-time | $189,309         | 2023-12-07 |
| 310660  | Principal Data Analyst, AV Performance Analysis    | Motional                                  | Anywhere  | Full-time | $189,000         | 2023-01-05 |
| 1749593 | Principal Data Analyst                             | SmartAsset                                | Anywhere  | Full-time | $186,000         | 2023-07-11 |
| 1638595 | Senior Data Analyst                                | Patterned Learning AI                     | Anywhere  | Full-time | $185,000         | 2023-08-15 |
| 387860  | ERM Data Analyst                                   | Get It Recruit - Information Technology   | Anywhere  | Full-time | $184,000         | 2023-06-09 |
| 813346  | Senior Data Analyst, GTM (South Bay, CA or Remote) | Zoom Video Communications                 | Anywhere  | Full-time | $181,000         | 2023-05-27 |


### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    sd.skills,
    COUNT(sjd.job_id) AS demand_count
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
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
| Skill     | Demand Count |
|-----------|--------------|
| SQL       | 7,291        |
| Excel     | 4,611        |
| Python    | 4,330        |
| Tableau   | 3,745        |
| Power BI  | 2,609        |

- SQL dominates the market — it remains the most in-demand core skill in data analytics.

- Excel is still highly relevant, proving traditional tools are far from obsolete.

- Python ranks third, showing strong demand for programming-based analysis.

- Visualization tools (Tableau & Power BI) are essential but secondary to core data handling skills.

- Overall trend: Foundational data skills (SQL + Excel + Python) drive the majority of job demand.

### 4.  Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
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
```

| Skill           | Avg Salary (USD) |
|-----------------|------------------|
| PySpark        | 208,172          |
| Bitbucket      | 189,155          |
| Couchbase      | 160,515          |
| Watson         | 160,515          |
| DataRobot      | 155,486          |
| GitLab         | 154,500          |
| Swift          | 153,750          |
| Jupyter        | 152,777          |
| Pandas         | 151,821          |
| Elasticsearch  | 145,000          |
| Golang         | 145,000          |
| NumPy          | 143,513          |
| Databricks     | 141,907          |
| Linux          | 136,508          |
| Kubernetes     | 132,500          |
| Atlassian      | 131,162          |
| Twilio         | 127,000          |
| Airflow        | 126,103          |
| Scikit-learn   | 125,781          |
| Jenkins        | 125,436          |
| Notion         | 125,000          |
| Scala          | 124,903          |
| PostgreSQL     | 123,879          |
| GCP            | 122,500          |
| MicroStrategy  | 121,619          |

- PySpark leads by a large margin, showing that big data processing skills command the highest salaries.

- Cloud and DevOps tools (Databricks, Kubernetes, GCP, GitLab, Jenkins) significantly boost earning potential.

- AI/ML platforms (DataRobot, Watson, Scikit-learn) are strongly associated with higher compensation.

- Modern data infrastructure tools (Couchbase, Elasticsearch) pay more than traditional database skills alone.

- Python ecosystem tools (Pandas, NumPy, Jupyter) are valuable but sit slightly below big data and engineering skills in salary impact.

- Overall trend: Engineering, scalable systems, and production-level data skills pay more than pure analysis tools.

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) AS demand_count,
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
    jf.job_title_short = 'Data Analyst'
    AND jf.job_work_from_home = TRUE
    AND jf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skill_id,
    sd.skills
HAVING
    COUNT(sjd.job_id) > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC;
```
| Skill        | Demand Count | Avg Salary (USD) |
|-------------|-------------|------------------|
| SQL         | 398         | 97,237           |
| Excel       | 256         | 87,288           |
| Python      | 236         | 101,397          |
| Tableau     | 230         | 99,288           |
| R           | 148         | 100,499          |
| Power BI    | 110         | 97,431           |
| SAS         | 63          | 98,902           |
| PowerPoint  | 58          | 88,701           |
| Looker      | 49          | 103,795          |
| Word        | 48          | 82,576           |
| Snowflake   | 37          | 112,948          |
| Oracle      | 37          | 104,534          |
| SQL Server  | 35          | 97,786           |
| Azure       | 34          | 111,225          |
| AWS         | 32          | 108,317          |
| Sheets      | 32          | 86,088           |
| Flow        | 28          | 97,200           |
| Go          | 27          | 115,320          |
| SPSS        | 24          | 92,170           |
| VBA         | 24          | 88,783           |
| Hadoop      | 22          | 113,193          |
| Jira        | 20          | 104,918          |
| JavaScript  | 20          | 97,587           |
| SharePoint  | 18          | 81,634           |
| Java        | 17          | 106,906          |
| Alteryx     | 17          | 94,145           |
| Redshift    | 16          | 99,936           |
| SSRS        | 14          | 99,171           |
| BigQuery    | 13          | 109,654          |
| NoSQL       | 13          | 101,414          |
| Qlik        | 13          | 99,631           |
| Spark       | 13          | 99,077           |
| Outlook     | 13          | 90,077           |
| SSIS        | 12          | 106,683          |
| Confluence  | 11          | 114,210          |
| C++         | 11          | 98,958           |


- SQL has the highest demand (398 postings), proving it remains the core skill in data analytics.

- Excel is still heavily requested, showing traditional tools are highly valued alongside modern tech.

- Python, R, and Tableau balance strong demand with solid salaries (~$99K–$101K).

- Cloud & data warehouse tools (Snowflake, Azure, AWS, BigQuery) offer higher-than-average salaries despite lower demand.

- Engineering-focused skills (Go, Hadoop, Spark) command some of the highest salaries but appear in fewer postings.

- Overall trend: Foundational skills drive demand, while cloud and big data skills drive higher pay.

# What I Learned
Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

# Conclusions

### **Insights**

From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

