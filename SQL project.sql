Create database `Manufecturing Project`;
Use `Manufecturing Project`;
 -- 1. Manufactured Qty and Rejected Qty
Select sum(`Manufactured Qty`) as`Manufactured Qty`,
sum(`Rejected Qty`) as`Rejected Qty`
from `prod dataset`;

SELECT 
    CONCAT(ROUND(SUM(`Manufactured Qty`) / 1000000, 2), ' M') AS `Manufactured Qty`,
    CONCAT(ROUND(SUM(`Rejected Qty`) / 1000, 2), ' K')     AS `Rejected Qty`
FROM `prod dataset`;


-- 2. Wastage Qty %
select concat(Round((Sum(`Rejected Qty`)/SUM(`Processed Qty`)*100),2), "%") 
as `Wastage Qty`
from`prod dataset`;

-- 3. Total Employees and Machines
select count(DISTINCT `Emp Name`) as `Total No of Employees`, 
count(DISTINCT `Machine Name`) as `Total No of Machines` 
from `prod dataset`;

-- 4. View - Top 10 Employees wise Rejected Qty
-- Create view `Top 10 Employees` as
Select `Emp Name`, CONCAT(ROUND(SUM(`Rejected Qty`) / 1000, 2), ' K') as`Rejected Qty`
from `prod dataset`
group by `Emp Name`
order by `Rejected Qty` desc
limit 10;

Select *from `Top 10 Employees`;

-- 5. View - Top 10 Machines Rejected Qty
-- Create view `Top 10 Machines` as
Select `Machine Name`, CONCAT(ROUND(SUM(`Rejected Qty`) / 1000, 2), ' K') as`Rejected Qty`
from `prod dataset`
group by `Machine Name`
order by `Rejected Qty` desc
limit 10;

Select *from `Top 10 Machines`;

-- 6. Department wise Manufactured Qty & Rejected Qty
select `Department Name`, CONCAT(ROUND(SUM(`Manufactured Qty`) / 1000000, 2), ' M') as`Manufactured Qty`,
CONCAT(ROUND(SUM(`Rejected Qty`) / 1000, 2), ' K') as`Rejected Qty`
From `prod dataset`
group by `Department Name`;

-- 7. Date wise Manufactured Qty & Rejected Qty
select `Doc Date` as Date , 
CONCAT(ROUND(SUM(`Manufactured Qty`) / 1000000, 2), ' M') as`Manufactured Qty`,
CONCAT(ROUND(SUM(`Rejected Qty`) / 1000, 2), ' K') as`Rejected Qty`
From `prod dataset`
group by `Date`
order by `Date`;

-- 8. Count of Rejected Qty & Unrejected Qty  
 select    
    case 
        when `Rejected Qty` > 0 then 'Rejected QTY'
        else 'Unrejected QTY'
    end AS Rejection_status,
    count(`Emp Name`) `No of Qty`
from `prod dataset`
group by rejection_status;

-- 9. Create Store Procedure - 
DELIMITER $$
USE `manufecturing project`$$
CREATE PROCEDURE `GetEmployeeDetails` (`Employee Name` varchar(50) )
BEGIN
select *from `prod dataset`
where `Emp name` = `Employee Name`;
END$$

-- call GetEmployeeDetails ( 'raj kumar');


-- 10. index
CREATE INDEX idx_cust_code
ON `prod dataset` (`Cust Code`(10));

SELECT `Cust Code`,`Cust Name`, `Buyer`, `Department Name`
FROM `prod dataset`
WHERE `Cust Code` = 'C000589';


-- 11. after insert tigger

CREATE TABLE insert_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cust_code VARCHAR(50),
    cust_name VARCHAR(255),
    inserted_at DATETIME
);

INSERT INTO `prod dataset` (`Cust Code`, `Cust Name`)
VALUES ('C000999', 'TEST CUSTOMER');

-- select * from insert_log;

-- 12. window functions
SELECT 
    `Buyer`, `Doc Date`, 
-- CONCAT(ROUND(SUM(`Produced Qty`) / 1000000, 2), ' M') 
 `Produced Qty`,
    SUM(`Produced Qty`) OVER (
        PARTITION BY `Buyer`
        ORDER BY `Doc Date`
    ) AS running_total
FROM `prod dataset`
WHERE `Buyer` != '-';

Drop  table insert_log;