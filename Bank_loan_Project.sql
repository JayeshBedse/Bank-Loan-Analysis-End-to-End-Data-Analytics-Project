CREATE DATABASE Bank_Loan_Project;
USE Bank_loan_project;
DESC bank_loan_data;
SELECT*FROM bank_loan_data;

#Changing Data-type of date Columns :- 
# Add temporary DATE columns
ALTER TABLE bank_loan_project.bank_loan_data
ADD COLUMN issue_date_temp DATE,
ADD COLUMN last_credit_pull_date_temp DATE,
ADD COLUMN last_payment_date_temp DATE,
ADD COLUMN next_payment_date_temp DATE;
# Convert and copy data into temp columns
UPDATE bank_loan_project.bank_loan_data
SET 
    issue_date_temp = STR_TO_DATE(issue_date, '%d-%m-%Y'),
    last_credit_pull_date_temp = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
    last_payment_date_temp = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
    next_payment_date_temp = STR_TO_DATE(next_payment_date, '%d-%m-%Y');
# Drop old string columns
ALTER TABLE bank_loan_project.bank_loan_data
DROP COLUMN issue_date,
DROP COLUMN last_credit_pull_date,
DROP COLUMN last_payment_date,
DROP COLUMN next_payment_date;
# Rename temp columns to original names
ALTER TABLE bank_loan_project.bank_loan_data
CHANGE COLUMN issue_date_temp issue_date DATE NULL DEFAULT NULL,
CHANGE COLUMN last_credit_pull_date_temp last_credit_pull_date DATE NULL DEFAULT NULL,
CHANGE COLUMN last_payment_date_temp last_payment_date DATE NULL DEFAULT NULL,
CHANGE COLUMN next_payment_date_temp next_payment_date DATE NULL DEFAULT NULL;
# Ensure ID is primary key
ALTER TABLE bank_loan_project.bank_loan_data
CHANGE COLUMN id id INT NOT NULL,
ADD PRIMARY KEY (id);

desc bank_loan_data;
SELECT*FROM bank_loan_data;
# Key Processing Indicators---

# Total Loan Applications
select count(id) as Total_Applications from bank_loan_data;

#MTD Loan Applications
SELECT COUNT(id) AS Total_Applications FROM bank_loan_data
WHERE MONTH(issue_date) = 12;
 
#PMTD Loan Applications
SELECT COUNT(id) AS Total_Applications FROM bank_loan_data
WHERE MONTH(issue_date) = 11;
 
#Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan_data;
 
#MTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan_data
WHERE MONTH(issue_date) = 12;
 
#PMTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan_data
WHERE MONTH(issue_date) = 11;
 


#Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bank_loan_data;
 
#MTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bank_loan_data
WHERE MONTH(issue_date) = 12;
 
#PMTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bank_loan_data
WHERE MONTH(issue_date) = 11;
 
#Average Interest Rate
SELECT AVG(int_rate)*100 AS Avg_Int_Rate FROM bank_loan_data;
 
#MTD Average Interest
SELECT AVG(int_rate)*100 AS MTD_Avg_Int_Rate FROM bank_loan_data
WHERE MONTH(issue_date) = 12;
 
#PMTD Average Interest
SELECT AVG(int_rate)*100 AS PMTD_Avg_Int_Rate FROM bank_loan_data
WHERE MONTH(issue_date) = 11;
 
#Avg DTI
SELECT AVG(dti)*100 AS Avg_DTI FROM bank_loan_data;
 
#MTD Avg DTI
SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(issue_date) = 12;
 
#PMTD Avg DTI
SELECT AVG(dti)*100 AS PMTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(issue_date) = 11;
 
#GOOD LOAN ISSUED
#Good Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data;
 
#Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';
 
#Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';
 
#Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

#BAD LOAN ISSUED
#Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data;
 
#Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off';
 
#Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Charged Off';
 
#Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Charged Off';
 
#LOAN STATUS
	SELECT
        loan_status,
        COUNT(id) AS LoanCount,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        bank_loan_data
    GROUP BY
        loan_status;
 

SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;
 





#   B.	BANK LOAN REPORT | OVERVIEW
#MONTH
SELECT 
    MONTH(issue_date) AS Month_Number,
    MONTHNAME(issue_date) AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_project.bank_loan_data
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);
 
#STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state;
 

#TERM
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term;
 

#EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;
 
#PURPOSE
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;
 
#HOME OWNERSHIP
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;
 

#Note: We have applied multiple Filters on all the dashboards. You can check the results for the filters as well by modifying the query and comparing the results.
#For e.g
#See the results when we hit the Grade A in the filters for dashboards.
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;



