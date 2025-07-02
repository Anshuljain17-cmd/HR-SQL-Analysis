CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

CREATE TABLE departments (
    dept_id VARCHAR(10) PRIMARY KEY,
    dept_name VARCHAR(50),
    manager_id VARCHAR(10)
);

CREATE TABLE performance (
    emp_id VARCHAR(10),
    year INT,
    performance_rating INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

show tables;

-- INSERT Sample Data
 INSERT INTO employees (emp_id, name, department, salary, hire_date) VALUES
('E001', 'Ankit', 'Sales', 50000, '2021-01-10'),
('E002', 'Sonal', 'Marketing', 60000, '2020-03-15'),
('E003', 'Ravi', 'Sales', 45000, '2022-07-25'),
('E004', 'Preeti', 'HR', 55000, '2019-11-05'),
('E005', 'Aman', 'Marketing', 52000, '2021-06-18');

INSERT INTO departments (dept_id, dept_name, manager_id) VALUES
('D01', 'Sales', 'E001'),
('D02', 'Marketing', 'E002'),
('D03', 'HR', 'E004');

INSERT INTO performance (emp_id, year, performance_rating) VALUES
('E001', 2023, 4),
('E002', 2023, 3),
('E003', 2023, 5),
('E004', 2023, 2),
('E005', 2023, 4);

-- QUERY 1: Department-wise Average Salary

  SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- Query 2: Find the Highest Paid Employee in Each Department
SELECT *
FROM (
    SELECT 
        emp_id,
        name,
        department,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employees
) AS ranked_employees
WHERE salary_rank = 1;

-- Query 3: Department-Wise Headcount
SELECT 
  department,
  COUNT(emp_id) AS total_employees
FROM 
  employees
GROUP BY 
  department;

-- Query 4: Year-wise New Joiners
SELECT 
  YEAR(hire_date) AS join_year,
  COUNT(emp_id) AS total_hired
FROM 
  employees
GROUP BY 
  join_year
ORDER BY 
  join_year;

-- Query 5: Top Performer per Department (Performance Rating)
SELECT *
FROM (
    SELECT 
        e.emp_id,
        e.name,
        e.department,
        p.performance_rating,
        RANK() OVER (PARTITION BY e.department ORDER BY p.performance_rating DESC) AS rating_rank
    FROM 
        employees e
    JOIN performance p ON e.emp_id = p.emp_id
    WHERE p.year = 2023
) AS ranked
WHERE rating_rank = 1;
