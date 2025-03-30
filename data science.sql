SELECT * FROM ds_salaries;

-- 1. apakah ada data yang null?
SELECT * FROM ds_salaries 
WHERE work_year IS NULL
OR experience_level IS NULL
OR employment_type IS NULL
OR job_title IS NULL
OR salary IS NULL
OR salary_currency IS NULL
OR salary_in_usd IS NULL
OR employee_residence IS NULL
OR remote_ratio IS NULL
OR company_location IS NULL
OR company_size IS NULL;

-- 2. melihat job title ada apa aja
SELECT DISTINCT job_title FROM ds_salaries ORDER BY job_title; 

-- 3. job title apa saja yang berkaitan dengan data analyst
SELECT DISTINCT job_title FROM ds_salaries WHERE job_title LIKE '%data analyst' ORDER BY job_title; 

-- 4. berapa rata-rata gaji data analyst 
SELECT (AVG(salary_in_usd)*15000)/12 AS salary_in_rp_monthly FROM ds_salaries;

-- 4.1 berapa rata-rata gaji data analyst berdasarkan experience level
SELECT experience_level, (AVG(salary_in_usd)*15000)/12 AS salary_in_rp_monthly 
FROM ds_salaries 
GROUP BY experience_level;

-- 4.2 berapa rata-rata gaji data analyst berdasarkan experience level dan jenis employeenya
SELECT experience_level, employment_type, (AVG(salary_in_usd)*15000)/12 AS salary_in_rp_monthly 
FROM ds_salaries 
GROUP BY experience_level, employment_type 
ORDER BY experience_level, employment_type;

-- 5. NEGARA dengan gaji yang menarik untuk posisi data analyst, fulltime, exp kerjanya mid/menengah dan entry level
SELECT company_location, AVG(salary_in_usd) AS avg_sal_in_usd FROM ds_salaries 
WHERE job_title LIKE '%data analyst%' AND employment_type = 'FT' AND experience_level IN ('MI', 'EN') 
GROUP BY company_location
HAVING avg_sal_in_usd >= 20000;
-- (experience_level = 'MI' OR experience_level = 'EN') bisa dignti dgn IN

-- 6. Ditahun berapa kenaikan gaji dari mid ke senior memiliki kenaikan yang tertinggi
-- (untuk pekerjaan berkaitan data analyst, fulltime)
-- membuat tabel sementara dengn with
WITH ds_1 AS (
	SELECT work_year, AVG(salary_in_usd) AS sal_in_usd_ex 
    FROM ds_salaries 
    WHERE employment_type = 'FT' AND experience_level = 'EX' AND job_title LIKE '%data analyst%' 
    GROUP BY work_year
), ds_2 AS (
	SELECT work_year, AVG(salary_in_usd) AS sal_in_usd_mid 
    FROM ds_salaries 
    WHERE employment_type = 'FT' AND experience_level = 'MI' AND job_title LIKE '%data analyst%' 
    GROUP BY work_year
), t_year AS (
	SELECT DISTINCT work_year FROM ds_salaries
) SELECT t_year.work_year, ds_1.sal_in_usd_ex, 
	ds_2.sal_in_usd_mid, ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mid difference
FROM t_year 
LEFT JOIN ds_1 ON ds_1.work_year = t_year.work_year 
LEFT JOIN ds_2 ON ds_2.work_year = t_year.work_year;