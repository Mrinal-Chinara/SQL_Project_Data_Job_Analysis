--UNION
SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs
 

--UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs


--Diferrence between UNION and UNION ALL: UNION removes duplicate records from the result set, while UNION ALL includes all records, including duplicates.    

--Q.Get the corresponding skill and skill type for each job posting for above
--Includes those without any skills, too
--Why? Look at the skills and the type for each job in the first quarter that has a salary > $70,000
WITH q1_jobs AS (
    SELECT 
        job_id,
        job_title_short,
        company_id,
        job_location,
        salary_year_avg
    FROM 
        january_jobs

    UNION

    SELECT 
        job_id,
        job_title_short,
        company_id,
        job_location,
        salary_year_avg
    FROM 
        february_jobs

    UNION

    SELECT 
        job_id,
        job_title_short,
        company_id,
        job_location,
        salary_year_avg
    FROM 
        march_jobs
)
SELECT 
    q1.job_id,
    q1.job_title_short,
    q1.company_id,
    q1.job_location,
    q1.salary_year_avg,
    s.skills AS skill_name,
    s.type AS skill_type
FROM 
    q1_jobs AS q1
LEFT JOIN 
    skills_job_dim AS sj ON q1.job_id = sj.job_id
LEFT JOIN 
    skills_dim AS s ON sj.skill_id = s.skill_id
WHERE 
    q1.salary_year_avg > 70000
ORDER BY 
    q1.salary_year_avg DESC;



--Find job postings from the first quarter that have a salary greater than $70K
--Combine job posting tables from the first quarter of 2023 (Jan-Mar)
--Gets job postings with an average yearly salary > $70,000
SELECT 
    job_id,
    job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT * FROM january_jobs
    UNION ALL
    SELECT * FROM february_jobs
    UNION ALL
    SELECT * FROM march_jobs
) AS q1_job
WHERE 
    salary_year_avg > 70000
    AND
    job_title_short = 'Data Analyst'
ORDER BY 
    salary_year_avg DESC;