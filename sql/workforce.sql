DROP TABLE IF EXISTS workforce_data;

CREATE TABLE workforce_data (
    department VARCHAR(50),
    job_role VARCHAR(100),
    salary FLOAT,
    overtime VARCHAR(10),
    overtime_hours FLOAT,
    hours_worked FLOAT,
    projects_handled INT,
    performance_rating FLOAT,
    productivity_score FLOAT,
    years_at_company INT,
    attrition VARCHAR(10)
);
select * from workforce_data;


--QUERY 1 — OVERTIME COST LEAKAGE
SELECT 
    department,
    ROUND(SUM((overtime_hours * (salary/160))::numeric),2) AS overtime_cost
FROM workforce_data
GROUP BY department
ORDER BY overtime_cost DESC;


--QUERY 2 — DEPARTMENT EFFICIENCY SCORE
SELECT 
    department,
    ROUND(AVG(productivity_score)::numeric,2) AS avg_productivity,
    SUM(overtime_hours) AS total_overtime
FROM workforce_data
GROUP BY department
ORDER BY total_overtime DESC;


--QUERY 3 — HIGH RISK EMPLOYEES
SELECT 
    department,
    overtime_hours,
    productivity_score
FROM workforce_data
WHERE overtime_hours > 10
AND productivity_score < 0.65
ORDER BY overtime_hours DESC;


--QUERY 4 — COST LEAKAGE %
SELECT 
    ROUND(
        (SUM(overtime_hours) / SUM(hours_worked) * 100)::numeric, 
        2
    ) AS cost_leakage_percent
FROM workforce_data;


--QUERY 5 — ATTRITION RISK BY DEPARTMENT
SELECT 
    department,
    COUNT(*) FILTER (WHERE attrition = 'Yes') AS attrition_count,
    COUNT(*) AS total_employees
FROM workforce_data
GROUP BY department
ORDER BY attrition_count DESC;


--QUERY 6 — TOP COST DRIVERS
SELECT 
    job_role,
    ROUND(SUM(overtime_hours * (salary/160))::numeric,2) AS cost
FROM workforce_data
GROUP BY job_role
ORDER BY cost DESC
LIMIT 5;


select * from workforce_data;