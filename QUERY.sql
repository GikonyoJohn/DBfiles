call employees.select_salaries();

DELIMITER $$
USE employees $$
create procedure emp_salary (IN p_emp_no INTEGER)
BEGIN
select
	e.first_name, e.last_name, s.salary, s.from_date, s.to_date
from 
	employees e
		JOIN 
	salaries s on e.emp_no = s.emp_no
where 
	e.emp_no = p_emp_no;
END$$

DELIMITER ;

DELIMITER $$
USE employees $$
create procedure emp_AVG_salary (IN p_emp_no INTEGER)
BEGIN
select
	e.first_name, e.last_name, AVG(s.salary) AS avg_salary
from 
	employees e
		JOIN 
	salaries s on e.emp_no = s.emp_no
where 
	e.emp_no = p_emp_no
group by e.emp_no;
END$$

DELIMITER ;


DELIMITER $$
create procedure emp_avg_salary_out(in p_emp_no integer, out p_avg_salary DECIMAL(10,2))
BEGIN
SELECT 
	AVG(s.salary)
INTO p_avg_salary FROM 
	employees e
		join 
	salaries s on emp_no = s.emp_no
where
	e.emp_no = p_emp_no;
END$$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(50), p_last_name VARCHAR(50), OUT p_emp_no INT)
BEGIN
	select e.emp_no
	INTO p_emp_no
    from employees e
    
    where e.first_name = p_first_name
    and last_name = p_last_name
    
    limit 1;
END$$
DELIMITER ;
END$$

DELIMITER ;


SET @v_avg_salary = 0;
call employees.emp_avg_salary_out(11300, @v_avg_salary);
SELECT @v_avg_salary;


SET @v_emp_no = 0;
call employees.emp_info('Aruna', 'Journel', @v_emp_no);
select @v_emp_no;

use  employees;
DROP FUNCTION IF EXISTS f_emp_avg_salary;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

DECLARE v_avg_salary DECIMAL(10,2);

SELECT
	AVG(s.salary)
INTO
	v_avg_salary
    from employees e
    JOIN 
    salaries s on e.emp_no = s.emp_no
    where 
    e.emp_no = p_emp_no;
RETURN v_avg_salary;
END$$

DELIMITER ;

DELIMITER $$
CREATE FUNCTION emp_info (p_first_name VARCHAR(20), P_last_name VARCHAR(20)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_max_from_date DATE;
    DECLARE v_salary DECIMAL(10,2);

    -- Get the most recent salary start date
    SELECT MAX(s.from_date)
    INTO v_max_from_date
    FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no
    WHERE e.first_name = p_first_name
      AND e.last_name = p_last_name;

    -- Get the salary for that latest contract
    SELECT s.salary
    INTO v_salary
    FROM employees e
    JOIN salaries s ON e.emp_no = s.emp_no
    WHERE e.first_name = p_first_name
      AND e.last_name = p_last_name
      AND s.from_date = v_max_from_date
    LIMIT 1;

    RETURN v_salary;
END$$

DELIMITER ;



