SELECT 
job_title AS title,
job_location AS location,
job_posted_date::DATE AS date
FROM 
job_postings_fact;

SELECT 
job_title AS title,
job_location AS location,
job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date
FROM 
job_postings_fact LIMIT 10;


SELECT 
job_title AS title,
job_location AS location,
job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
EXTRACT (YEAR FROM job_posted_date ) AS year,
EXTRACT (MONTH FROM job_posted_date ) AS month,
EXTRACT (DAY FROM job_posted_date ) AS day
FROM 
job_postings_fact LIMIT 10;


//--------------------------------------------------------------------------------------------------



SELECT
COUNT(job_id) AS job_posted_count,
EXTRACT (MONTH FROM job_posted_date ) AS month
FROM
job_postings_fact
WHERE 
job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY
job_posted_count DESC;
