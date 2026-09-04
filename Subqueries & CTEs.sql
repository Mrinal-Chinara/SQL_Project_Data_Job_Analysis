--Subquery
SELECT *
 FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
 ) AS january_jobs


--Common Table Expression (CTE)
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
)
SELECT *
FROM january_jobs


--Q. find the company (name, id) for jobs that does not need a degree.

SELECT company_id , name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
)

--Q. find the company (name, id) for jobs that does not need a degree using CTE.
WITH no_degree_jobs AS (
    SELECT
        company_id
    FROM 
        job_postings_fact
    WHERE 
        job_no_degree_mention = TRUE
)
SELECT 
    c.company_id,
    c.name AS company_name
FROM 
    company_dim AS c
INNER JOIN 
    no_degree_jobs AS ndj ON c.company_id = ndj.company_id;




--Q.find the companies that have the most job openings.
-- get the total number of job postings per company id(job_postings_fact).
--Return the total number of jobs with the company name(company_dim).
WITH company_jobs_count AS (
   SELECT company_id,
   COUNT(*) AS total_jobs
   FROM 
   job_postings_fact
   GROUP BY 
   company_id
)
SELECT 
   company_dim.name AS company_name,
   company_jobs_count.total_jobs
FROM 
   company_dim
LEFT JOIN 
   company_jobs_count ON company_jobs_count.company_id = company_dim.company_id
ORDER BY 
   total_jobs DESC



--Q.Identify the top 5 skills that are most frequently mentioned in job postings.
--Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table and then join this result with the skills_dim table to get the skill names.
SELECT 
    s.skill_id,
    s.skills AS skill_name,
    top_skills.skill_count
FROM (
    SELECT 
        skill_id,
        COUNT(job_id) AS skill_count
    FROM 
        skills_job_dim
    GROUP BY 
        skill_id
    ORDER BY 
        skill_count DESC
    LIMIT 5
) AS top_skills
INNER JOIN 
    skills_dim AS s ON top_skills.skill_id = s.skill_id
ORDER BY 
    top_skills.skill_count DESC;



--Q.Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of job postings they have.
-- Use a subquery to calculate the total job postings per company. A company is considered 'Small' if it has less than 10 job postings, 'Medium' if the number of job postings is between 10 and 50, and 'Large' if it has more than 50 job postings. 
--Implement a subquery to aggregate job counts per company before classifying them based on size.    
SELECT 
    c.company_id,
    c.name AS company_name,
    job_counts.total_postings,
    CASE 
        WHEN job_counts.total_postings < 10 THEN 'Small'
        WHEN job_counts.total_postings BETWEEN 10 AND 50 THEN 'Medium'
        WHEN job_counts.total_postings > 50 THEN 'Large'
    END AS company_size
FROM (
    SELECT 
        company_id,
        COUNT(job_id) AS total_postings
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
) AS job_counts
INNER JOIN 
    company_dim AS c ON job_counts.company_id = c.company_id
ORDER BY 
    job_counts.total_postings DESC;