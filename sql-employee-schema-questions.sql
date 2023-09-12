--
-- drop tables and their cascaded dependcies
--
DROP TABLE IF EXISTS departments CASCADE;


DROP TABLE IF EXISTS dept_emp CASCADE;


DROP TABLE IF EXISTS dept_manager CASCADE;


DROP TABLE IF EXISTS employees CASCADE;


DROP TABLE IF EXISTS salaries CASCADE;


DROP TABLE IF EXISTS titles CASCADE;


--
-- no foreign keys since tables created out of dependency order
--
-- create departments table
CREATE TABLE departments (
    dept_no VARCHAR NOT NULL,
    dept_name VARCHAR NOT NULL,
    PRIMARY KEY (dept_no)
);


-- create dept_emp table
CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR NOT NULL,
    -- FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    -- FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);


-- create dept_manager table
CREATE TABLE dept_manager (
    dept_no VARCHAR NOT NULL,
    emp_no INT NOT NULL,
    -- FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    -- FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (dept_no, emp_no)
);


-- create employees table
CREATE TABLE employees (
    emp_no INT NOT NULL,
    emp_title_id VARCHAR NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    sex VARCHAR NOT NULL,
    hire_date DATE NOT NULL,
    -- FOREIGN KEY (emp_title_id) REFERENCES titles (title_id),
    PRIMARY KEY (emp_no)
);


-- create salaries table
CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    -- FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no)
);


-- create titles table
CREATE TABLE titles (
    title_id VARCHAR NOT NULL,
    title VARCHAR NOT NULL,
    PRIMARY KEY (title_id)
);


--
-- all tables created, now add foreign keys
--
-- foreign keys for dept_emp table
ALTER TABLE
    dept_emp
ADD
    CONSTRAINT fk_dept_emp_emp_no 
		FOREIGN KEY(emp_no) REFERENCES employees (emp_no),
ADD
    CONSTRAINT fk_dept_emp_dept_no 
		FOREIGN KEY(dept_no) REFERENCES departments (dept_no);


-- foreign keys for dept_manager table
ALTER TABLE
    dept_manager
ADD
    CONSTRAINT fk_dept_manager_emp_no 
		FOREIGN KEY(emp_no) REFERENCES employees (emp_no),
ADD
    CONSTRAINT fk_dept_manager_dept_no 
		FOREIGN KEY(dept_no) REFERENCES departments (dept_no);


-- foreign key for employee table
ALTER TABLE
    employees
ADD
    CONSTRAINT fk_employees_emp_title_id 
		FOREIGN KEY(emp_title_id) REFERENCES titles (title_id);


-- foreign key for salaries table
ALTER TABLE
    salaries
ADD
    CONSTRAINT fk_salaries_emp_no 
		FOREIGN KEY(emp_no) REFERENCES employees (emp_no);

        -- Salary by employee
SELECT  emp.emp_no,
        emp.last_name,
        emp.first_name,
        emp.sex,
        sal.salary
FROM employees as emp
    LEFT JOIN salaries as sal
    ON (emp.emp_no = sal.emp_no)
ORDER BY emp.emp_no;

-- Employees hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';

-- Manager of each department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        e.last_name,
        e.first_name
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN employees AS e
        ON (dm.emp_no = e.emp_no);


-- Department of each employee
SELECT  e.emp_no,
        e.last_name,
        e.first_name,
        d.dept_name
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no)
ORDER BY e.emp_no;

-- Employees whose first name is "Hercules" and last name begins with "B"
SELECT first_name, last_name, birth_date, sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

-- Employees in the Sales department
SELECT  e.emp_no,
        e.last_name,
        e.first_name,
        d.dept_name
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales'
ORDER BY e.emp_no;

-- Employees in Sales and Development departments
SELECT  e.emp_no,
        e.last_name,
        e.first_name,
        d.dept_name
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development')
ORDER BY e.emp_no;

-- The frequency of employee last names
SELECT last_name, COUNT(last_name)
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;