-- SELECT statements
-- 1.	List all the data in the classic models database tables:

-- a)	ProductLines Table
SELECT * FROM ProductLines;
DESCRIBE ProductLines;
SELECT COUNT(*) FROM ProductLines;

-- b)	Products Table
SELECT * FROM Products;
DESCRIBE Products;
SELECT COUNT(*) FROM Products;

-- c)	Employees Table
SELECT * FROM Employees;
DESCRIBE Employees;
SELECT COUNT(*) FROM Employees;

-- d)	Offices Table
SELECT * FROM Offices;
DESCRIBE Offices;
SELECT COUNT(*) FROM Offices;

-- e)	Customers Table
SELECT * FROM Customers;
DESCRIBE Offices;
SELECT COUNT(*) FROM Offices;

-- f)	Orders Table
SELECT * FROM Orders;
DESCRIBE Orders;
SELECT COUNT(*) FROM Orders;

-- g)	Orderdetails Table
SELECT * FROM OrderDetails;
DESCRIBE OrderDetails;
SELECT COUNT(*) FROM OrderDetails;

-- h)	Payments (273)
SELECT * FROM Payments;
DESCRIBE Payments;
SELECT COUNT(*) FROM Payments;


-- 2.	Select customer name from customer. Sort by customer name (122)
SELECT c.customername
FROM Customers AS c
ORDER BY c.customername ASC;

-- 3.	List each of the different status that an order may be in (6)
SELECT DISTINCT o.status 
FROM Orders AS o;

-- 4.	List firstname and lastname for each employee. Sort by lastname then firstname (23)
SELECT e.firstname, e.lastname 
FROM Employees AS e
ORDER BY e.lastname, e.firstname;

-- 5.	List all the employee job titles (7)
SELECT DISTINCT e.jobtitle 
FROM Employees AS e;

-- 6.	List all products along with their product scale (110)
SELECT p.productname, p.productscale 
FROM Products AS p;

-- 7.	List all the territories where we have Offices (4)
SELECT DISTINCT o.territory 
FROM Offices AS o;



-- WHERE Clause
-- 8.	select contact firstname, contact lastname and credit limit for all Customers where credit limit > 50000 (85)
SELECT c.contactfirstname, c.contactlastname, c.creditlimit 
FROM Customers AS c
WHERE c.creditlimit > 50000;

-- 9.	select Customers who do not have a credit limit (0.00) (24)
SELECT c.contactfirstname, c.contactlastname 
FROM Customers AS c
WHERE c.creditlimit = 0;

-- 10.	List all Offices not in the USA (4)
SELECT o.officecode
FROM Offices AS o
WHERE country!='USA';

-- 11.	List Orders made between June 16, 2014 and July 7, 2014 (8)
SELECT o.ordernumber
FROM Orders AS o
WHERE o.orderdate BETWEEN '2014-06-16' AND '2014-07-07';

-- 12.	List products that we need to reorder (quantityinstock < 1000) (12)
SELECT p.productname
FROM Products AS p
WHERE p.quantityinstock < 1000;

-- 13.	List all Orders that shipped after the required date (1)
SELECT o.ordernumber
FROM Orders AS o
WHERE o.shippeddate > o.requireddate;

-- 14.	List all Customers who have the word 'Mini' in their name (10)
SELECT c.customername
FROM Customers AS c
WHERE c.customername like '%Mini%';

-- 15.	List all products supplied by 'Highway 66 Mini Classics' (9)
SELECT p.productname
FROM Products AS p
WHERE p.productVendor = 'Highway 66 Mini Classics';

-- 16.	List all product not supplied by 'Highway 66 Mini Classics' (101)
SELECT p.productname
FROM Products AS p
WHERE p.productvendor != 'Highway 66 Mini Classics';

-- 17.	List all employees that don't have a manager (1)
SELECT e.employeeNumber, e.firstname, e.lastname
FROM Employees AS e
WHERE reportsto IS NULL;



-- NATURAL JOIN
-- 18.	Display every order along with the details of that order for order numbers 10270, 10272, 10279 (23)
-- Hint: this can be done two ways. Try both of them. Which is easier if you have a large number of selection criteria?
-- method 1 using OR:
SELECT ordernumber, productcode, quantityordered, priceeach, orderlinenumber
FROM Orders NATURAL JOIN OrderDetails
WHERE ordernumber = 10270 OR ordernumber = 10272 OR ordernumber = 10279; 
-- method 2 using IN:
SELECT ordernumber, productcode, quantityordered, priceeach, orderlinenumber
FROM Orders NATURAL JOIN OrderDetails
WHERE ordernumber IN(10270, 10272,10279);

-- 19.	List of ProductLines and vendors that supply the products in that productline. (65)
-- NOT THE ANSWER (JUST TO MORE CLEARLY SEE THE DUPLICATES):
SELECT productline, productvendor
FROM ProductLines NATURAL JOIN Products
ORDER BY productline, productvendor;
-- ACTUAL ANSWER FOR #19:
SELECT DISTINCT productline, productvendor
FROM ProductLines NATURAL JOIN Products;


-- Inner Join
-- 20.	select Customers that live in the same state as one of our Offices (26)
-- method 1:
SELECT c.customerName 
FROM Customers AS c
WHERE c.state IN (
    SELECT DISTINCT o.state FROM Offices AS o
);
-- method 2:
SELECT customername
FROM Customers INNER JOIN Offices
ON Customers.state = Offices.state;

-- 21.	select Customers that live in the same state as their employee representative works (26)
SELECT DISTINCT c.customername
FROM Customers AS c 
INNER JOIN (Employees NATURAL JOIN Offices AS EO)
ON Customers.state = EO.state;


-- Multi-JOIN
-- 22.	select customerName, orderDate, quantityOrdered, productLine, productName for all Orders made and shipped in 2015 (444)
SELECT customerName, orderDate, quantityOrdered, productLine, productName
FROM Orders NATURAL JOIN Customers NATURAL JOIN OrderDetails NATURAL JOIN products;
WHERE YEAR(orderdate) = 2015 AND YEAR(shippeddate) = 2015;



-- OUTER JOIN
-- 23.	List products that didn't sell (1)
-- method 1:
SELECT productName
FROM products p
LEFT JOIN OrderDetails od
ON p.productCode = od.productCode
WHERE orderNumber IS NULL;
-- method 2:
SELECT productName
FROM products
WHERE productCode NOT IN (
   SELECT DISTINCT productCode FROM OrderDetails
);

-- 24.	List all Customers and their sales rep even if they don't have a sales rep (122)
SELECT customerName, lastname, firstname
FROM Customers c LEFT JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber;

-- Aggregate Functions
-- 25.	Find the total of all Payments made by each customer (98)
SELECT customerName, SUM(amount) AS 'totalpayment'
FROM Customers NATURAL JOIN Payments
GROUP BY customerName;

-- 26.	Find the largest payment made by a customer (1)
SELECT MAX(amount)
FROM Payments;

-- 27.	Find the average payment made by a customer (1)
SELECT AVG(amount)
FROM Payments;

-- 28.	What is the total number of products per product line (7)
SELECT productline, COUNT(productname) AS numofproducts
FROM Products
GROUP BY productline;

-- 29.	What is the number of Orders per status (6)
SELECT status, COUNT(orderNumber)
FROM Orders 
GROUP BY status;

-- 30.	List all Offices and the number of employees working in each office (7)
SELECT officecode, COUNT(employeenumber)
FROM Employees
GROUP BY officecode;


-- HAVING
-- 31.	List the total number of products per product line where number of products > 3 (6)
SELECT productline, COUNT(productcode) AS numofproducts
FROM Products
GROUP BY productline
HAVING COUNT(productcode) > 3;

-- 32.	List the orderNumber and order total for all Orders that totaled more than $60,000.00.
SELECT ordernumber, SUM(quantityordered*priceeach) AS ordertotal
FROM OrderDetails
GROUP BY ordernumber
HAVING ordertotal > 60000;

-- Computations
-- 33.	List the products and the profit that we have made on them.  
--      The profit in each order for a given product is (priceEach - buyPrice) * quantityOrdered.  
--      List the product's name and code with the total profit that we have earned selling that product.  
--      Order the rows descending by profit. 
--      Only show those products whose profit is greater than $60,000.00. (11)

SELECT productname, productCode, SUM((priceEach-buyPrice)*quantityOrdered) AS 'profit'
FROM Orderdetails NATURAL JOIN Products
GROUP BY productname, productCode
HAVING profit > 60000
ORDER BY profit DESC;

-- 34.	List the average of the money spent on each product across all Orders 
--      where that product appears when the customer is based in Japan.  
--      Show these products in descending order by the average expenditure (45).
-- !NOTE!: WHERE cluase comes before GROUP BY.
-- method 1:
SELECT productcode, AVG(quantityordered*priceeach) AS averageamountspentonproduct
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails
WHERE country = 'Japan'
GROUP BY productcode
ORDER BY averageamountspentonproduct DESC;

-- method 2:
SELECT productcode, avg(quantityordered*priceeach) "average_value"
FROM OrderDetails 
JOIN Orders using (ordernumber)
JOIN Customers cust using (customernumber)
WHERE cust.country = 'Japan'
GROUP BY productcode
ORDER BY average_value DESC;


-- 35.	What is the profit per product (MSRP-buyprice) (110)
SELECT productname, (msrp - buyprice)
FROM products;

-- 36.	List the Customer Name and their total Orders (quantity * priceEach) 
--      across all Orders that the customer has ever placed with us,
--      in descending order by order total 
--      for those Customers who have ordered more than $100,000.00 from us. (32)
SELECT customerName, SUM(quantityOrdered*priceEach) as total
FROM Orderdetails NATURAL JOIN Orders NATURAL JOIN Customers
GROUP BY customerName
HAVING total > 100000
ORDER BY total DESC;


-- Set Operations
-- 37.	List all Customers who didn't order in 2015 (78)
-- method 1:
SELECT DISTINCT customerName 
FROM Customers NATURAL JOIN Orders
WHERE YEAR(orderDate) != 2015;
-- method 2
SELECT customerName From Customers
EXCEPT
SELECT DISTINCT customerName 
From Customers NATURAL JOIN Orders
WHERE YEAR(orderDate) = 2015;

-- 38.	List all people that we deal with (employees and customer contacts). 
--      Display first name, last name, company name (or employee) (145)

SELECT 'Employee' AS "Company Name", lastName AS "Last Name", firstName AS "First Name" 
FROM Employees
UNION
SELECT customerName AS "Company Name", contactLastName AS "Last Name", contactFirstName AS "First Name" 
FROM Customers;

-- 39.	List the last name, first name, and employee number of all of the employees who do not have any Customers.  
--      Order by last name first, then the first name. (8)
-- method 1:
SELECT DISTINCT lastname, firstname, employeeNumber
FROM Employees e
LEFT JOIN Customers c ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE customerNumber IS NULL
ORDER BY lastname, firstname;
-- method 2:
SELECT DISTINCT lastname, firstname, employeeNumber
FROM Employees
WHERE employeeNumber NOT IN (
   SELECT DISTINCT salesRepEmployeeNumber 
   FROM Customers
   WHERE salesRepEmployeeNumber IS NOT NULL
)
ORDER BY lastname, firstname;

-- 40.	List the states and the country that the state is part of that have 
--      Customers but not Offices, 
--      Offices but not Customers,
--      or both one or more Customers and one or more Offices all in one query.  
--      Designate which state is which with the string 'Customer', 'Office', or 'Both'.  
--      If a state falls into the "Both" category, do not list it as a Customer or an Office state.
--      Order by the country, then the state.
--      Give the category column (where you list 'Customer', 'Office', or 'Both') a header of "Category"
--      and exclude any entries in which the state is null. (19)
SELECT DISTINCT state, country, 'Customer' As category
FROM Customers
WHERE state IS NOT NULL AND (state, country) NOT IN (SELECT DISTINCT state, country FROM Offices)
UNION
SELECT DISTINCT state, country, 'Office' As category
FROM Offices
WHERE state IS NOT NULL AND (state, country) NOT IN (SELECT DISTINCT state, country FROM Customers)
UNION
SELECT DISTINCT state, country, 'Both' As category
FROM Offices
WHERE state IS NOT NULL AND (state, country) IN (SELECT DISTINCT state, country FROM Customers);

-- 41.	List the Product Code and Product name of every product that has never been 
--      in an order in which the customer asked for more than 48 of them.  
--      Order by the Product Name.  (8)
SELECT DISTINCT productCode, productName 
FROM Products
WHERE productCode NOT IN (
    SELECT DISTINCT productCode FROM OrderDetails
    WHERE quantityOrdered > 48
);

-- 42.	List the first name and last name of any customer who ordered any products
--      from either of the two product lines 'Trains' or 'Trucks and Buses'.
--      Do not use an "or".
--      Instead perform a union.  
--      Order by the customer's name.  (61)
SELECT DISTINCT contactlastname, contactfirstname
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails NATURAL JOIN Products
WHERE productLine = 'Trains'
UNION
SELECT DISTINCT contactlastname, contactfirstname
FROM Customers NATURAL JOIN Orders NATURAL JOIN OrderDetails NATURAL JOIN Products
WHERE productLine = 'Trucks and Buses'
ORDER BY contactlastname, contactfirstname;

-- 43.	List the name of all Customers who do not live in the same state and country with any other customer.  
-- method 1:
SELECT customerName FROM (SELECT state, customerName
FROM Customers
GROUP BY state, customerName
HAVING count(state) = 1) a;

-- Subqueries
-- 44.	What product that makes us the most money (qty*price) (1)
SELECT productName
FROM Products NATURAL JOIN OrderDetails
GROUP BY productName
HAVING SUM(quantityOrdered*priceEach) = 
(
    SELECT MAX(LIST_OF_PRODUCT_TOTALS.productTotal)
    FROM
    (
        SELECT  productCode, sum(quantityOrdered*priceEach) AS productTotal
        FROM  OrderDetails
        GROUP BY productCode
    ) AS LIST_OF_PRODUCT_TOTALS
);

-- 45.	List the product lines and vendors for product lines which are supported by < 5 vendors (3)
SELECT productLine, productVendor 
FROM Products 
WHERE productLine IN 
(
    SELECT productline
    FROM Products
    GROUP BY productLine
    HAVING COUNT(productVendor) < 5
); 

-- 46.	List the products in the product line with the most number of products (38)
SELECT productName FROM Products
WHERE productLine = 
(
    SELECT productLine
    FROM Products 
    GROUP BY productLine
    HAVING count(productCode) = 
    (
        SELECT MAX(a.product_count) FROM 
        (
            SELECT productLine, count(productCode) as product_count
            FROM Products 
            GROUP BY productLine
        ) as a
    )   
);

-- 47.	Find the first name and last name of all customer contacts
--      whose customer is located in the same state as the San Francisco office. (11)
SELECT contactFirstName, contactLastName 
FROM Customers 
WHERE state = 
    (
    SELECT state FROM Offices
    WHERE city = 'San Francisco'
    )
    AND state IS NOT NULL;

-- 48.	What is the customer and sales person of the highest priced order? (1)
-- method 1:
SELECT DISTINCT customerName, salesRepEmployeeNumber 
FROM Orderdetails NATURAL JOIN Orders NATURAL JOIN Customers
WHERE orderNumber = 
    (
    SELECT orderNumber
    FROM Orderdetails
    GROUP BY orderNumber
    HAVING SUM(quantityOrdered*priceEach) =
        (
        SELECT MAX(a.sum_order) 
        FROM 
            (
            SELECT orderNumber, SUM(quantityOrdered*priceEach) as sum_order
            FROM Orderdetails
            GROUP BY orderNumber
            ) as a
        )
    );
-- method 2:
SELECT customerName, salesRepEmployeeNumber
FROM Customers 
WHERE customerNumber =
(
    SELECT customerNumber
    FROM Orders
    WHERE orderNumber = 
    (
        SELECT orderNumber
        FROM OrderDetails
        GROUP BY orderNumber
        HAVING sum(priceEach*quantityOrdered) =
        (
            SELECT MAX(OrderTotals.orderTotal)
            FROM 
            (
                SELECT sum(priceEach*quantityOrdered) AS orderTotal
                FROM OrderDetails
                GROUP BY orderNumber
            ) AS OrderTotals
        )
    )
);

-- 49.	What is the order number and the cost of the order for the most expensive Orders?
--      Note that there could be more than one order which all happen to add up to the same cost,
--      and that same cost could be the highest cost among all Orders. (1)
SELECT orderNumber, sum(priceEach*quantityOrdered) AS "Order Total"
FROM OrderDetails
GROUP BY orderNumber
HAVING sum(priceEach*quantityOrdered) =
(
    SELECT MAX(OrderTotals.orderTotal)
    FROM 
    (
        SELECT sum(priceEach*quantityOrdered) AS orderTotal
        FROM OrderDetails
        GROUP BY orderNumber
    ) AS OrderTotals
);

-- 50.	What is the name of the customer, the order number,
--      and the total cost of the most expensive Orders? (1)
SELECT customerName, orderNumber, SUM(quantityOrdered*priceEach)
FROM Orderdetails NATURAL JOIN Orders NATURAL JOIN Customers
WHERE orderNumber = 
    (
    SELECT orderNumber
    FROM Orderdetails
    GROUP BY orderNumber
    HAVING SUM(quantityOrdered*priceEach) =
        (
        SELECT MAX(a.sum_order) 
        FROM 
            (
            SELECT orderNumber, SUM(quantityOrdered*priceEach) as sum_order
            FROM Orderdetails
            GROUP BY orderNumber
            ) as a
        )
    )
GROUP BY customerName, orderNumber;

-- 51.	Perform the above query using a view. (1)
----    YOU NEED TO RUN BOTH QUERIES BELOW:
----    However, in derby, there is no "OR REPLACE" so after the first time you
----    create the below view table, theres no way to replace it in the case
----    that some other order becomes the highest price order besides manually
----    dropping the view and running it again

CREATE VIEW V_ORDERNUMBER_OF_HIGHEST_PRICED_ORDER AS
(
    SELECT orderNumber
    FROM OrderDetails
    GROUP BY orderNumber
    HAVING sum(priceEach*quantityOrdered) =
    (
        SELECT MAX(OrderTotals.orderTotal)
        FROM 
        (
            SELECT sum(priceEach*quantityOrdered) AS orderTotal
            FROM OrderDetails
            GROUP BY orderNumber
        ) AS OrderTotals
    )
);
SELECT customerName, orderNumber, SUM(quantityOrdered*priceEach)
FROM Orderdetails NATURAL JOIN Orders NATURAL JOIN Customers
WHERE orderNumber = (SELECT ordernumber FROM V_ORDERNUMBER_OF_HIGHEST_PRICED_ORDER)
GROUP BY customerName, orderNumber;


-- 52.	Show all of the Customers who have ordered at least one product
--      with the name "Ford" in it, that "Dragon Souveniers, Ltd." has also ordered.  
--      List them in reverse alphabetical order,
--      and do not consider the case of the letters in the customer name in the ordering.
--      Show each customer no more than once. (61)
SELECT DISTINCT customerName
FROM OrderDetails NATURAL JOIN Products NATURAL JOIN Orders NATURAL JOIN Customers
WHERE productName IN
(
    SELECT productName
    FROM OrderDetails NATURAL JOIN Products NATURAL JOIN Orders NATURAL JOIN Customers
    WHERE customerName = "Dragon Souveniers, Ltd."
    AND productName IN 
    (
        SELECT productName 
        FROM Products
        WHERE LOWER(productName) LIKE "%ford%"
    )
)
ORDER BY customerName DESC;

-- 53.	Which products have an MSRP within 5% of the average MSRP across all products?
--      List the Product Name, the MSRP, and the average MSRP ordered by the product MSRP. (14)
SELECT productName, MSRP, AVG_MSRP
FROM
(
    SELECT productName, MSRP, (SELECT AVG(MSRP) FROM Products) as 'AVG_MSRP' 
    FROM Products 
) as a
WHERE (MSRP < 1.05 * AVG_MSRP) AND (MSRP > 0.95 * AVG_MSRP)

-- 54.	List all of the Customers who have never made a payment on the same date as another customer. (57)
SELECT DISTINCT customerName
FROM Customers NATURAL JOIN Payments
WHERE customerNumber IN
(
    SELECT p1.customerNumber
    FROM Payments p1, Payments p2
    WHERE p1.paymentdate = p2.paymentdate 
    AND p1.customerNumber != p2.customerNumber
)

-- 55.	Find Customers who have ordered the same thing.
--      Find only those customer pairs who have ordered the same thing as each other at least 201 times (1)
WITH cte AS (
    SELECT customerNumber, productCode
    FROM OrderDetails NATURAL JOIN Orders
    GROUP BY customerNumber, productCode
)
SELECT t1.customerNumber as c1, t2.customerNumber as c2
FROM cte t1
CROSS JOIN cte t2
WHERE t1.productCode = t2.productCode
AND t1.customerNumber != t2.customerNumber
GROUP BY c1, c2
-- HAVING COUNT(*) > 201
ORDER BY COUNT(*) DESC
LIMIT 10

-- 56.	What is the manager who manages the greatest number of employees (2)
SELECT employeeNumber, lastName, firstName
FROM Employees
WHERE employeeNumber IN
(
    SELECT reportsto
    FROM Employees
    GROUP BY reportsto
    HAVING COUNT(employeeNumber) = 
    (
        SELECT MAX(Manager.numOfEmployeesManaged)
        FROM 
        (
            SELECT reportsto, COUNT(employeeNumber) AS numOfEmployeesManaged
            FROM Employees
            GROUP BY reportsto
        ) AS Manager
    )
);

-- 57.	Select all employees who work for the manager that manages the greatest number of employee (12)
SELECT employeeNumber, lastName, firstName
FROM Employees
WHERE reportsto IN
(
    SELECT reportsto
    FROM Employees
    GROUP BY reportsto
    HAVING COUNT(employeeNumber) = 
    (
        SELECT MAX(Manager.numOfEmployeesManaged)
        FROM 
        (
            SELECT reportsto, COUNT(employeeNumber) AS numOfEmployeesManaged
            FROM Employees
            GROUP BY reportsto
        ) AS Manager
    )
);





-- 58.	List all employees that have the same last name. Make sure each combination is listed only once (5)
SELECT A.lastname, A.firstname, B.lastname, B.firstname
FROM employees A INNER JOIN employees B 
USING (lastname)
WHERE A.employeenumber > B.employeenumber;

-- 59.	Select the name of each of two Customers who have made at least one payment on the same date as the other.
--      Make sure that each pair of Customers only appears once. (46)
SELECT A.customernumber, A.paymentdate, B.customernumber, B.paymentdate
FROM Payments A INNER JOIN Payments B
USING (paymentdate)
WHERE A.customernumber > B.CUSTOMERNUMBER;
----    FULL ANSWER FOR #59:
SELECT Cus_A.customername, Cus_B.customername, A.PAYMENTDATE AS "Common Payment Date"
FROM (Payments A NATURAL JOIN Customers Cus_A) INNER JOIN (Payments B NATURAL JOIN Customers Cus_B) 
USING (paymentdate)
WHERE A.customernumber > B.customernumber;




-- 60.	Find Customers that share the same state and country.
--      The country must be one of the following: UK, Australia, Italy or Canada.
--      Remember that not all countries have states at all, so you need to substitute
--       a character sting like 'N/A' for the state in those cases so that you can compare the states.
WITH cte AS (
    SELECT customerName, customerNumber, country, CASE WHEN state IS NOT NULL THEN state ELSE 'NA' END AS new_state
    FROM Customers
)

SELECT a.customerName 'custumer1', b.customerName 'custumer2'
FROM cte a INNER JOIN cte b USING (country, new_state)
WHERE a.customerNumber > b.customerNumber
AND a.country IN ('UK', 'Australia', 'Italy', 'Canada');

-- 61.	Find all of the Customers who have the same sales representative as some other customer,
--      and either customer name has 'Australian' in it.
--      List each of the Customers sharing a sales representative, and the name of the sales representative.
--      Order by the name of the first customer, then the second.  Do not show any combination more than once. (9)
WITH cte AS (
    SELECT a.customerName 'custumer1', b.customerName 'custumer2', a.salesRepEmployeeNumber
    FROM Customers a INNER JOIN Customers b USING (salesRepEmployeeNumber)
    WHERE a.customerNumber > b.customerNumber
    AND (LOWER(a.customerName) LIKE "%australian%"
    OR LOWER(b.customerName) LIKE "%australian%")
)
SELECT custumer1, custumer2, firstName, lastName
FROM cte JOIN Employees ON cte.salesRepEmployeeNumber = Employees.employeeNumber;



