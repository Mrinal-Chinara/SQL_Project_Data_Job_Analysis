SELECT COUNT(job_id) AS total_jobs,
CASE
WHEN job_location = 'Anywhere' THEN 'Remote'
WHEN job_location = 'India' THEN 'Local'
ELSE 'On-site'
END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;


//QUESTION 

SELECT 
    job_id,
    job_title,
    salary_year_avg,
    CASE 
        WHEN salary_year_avg >= 120000 THEN 'High Salary'
        WHEN salary_year_avg BETWEEN 70000 AND 119999 THEN 'Standard Salary'
        WHEN salary_year_avg < 70000 THEN 'Low Salary'
        ELSE 'Salary Not Specified'
    END AS salary_bucket
FROM 
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC;