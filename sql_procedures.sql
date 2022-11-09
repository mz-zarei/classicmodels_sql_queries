-- 1. Create a procedure to return total orders

-- DELIMITER $$

CREATE PROCEDURE GetTotalOrder()
BEGIN
    -- decalre a variable
	DECLARE totalOrder INT DEFAULT 0;
    
    -- assign value to the variable
    SELECT COUNT(*) 
    INTO totalOrder
    FROM orders;

    -- return the result
    SELECT totalOrder;
END;

-- DELIMITER ;

-- call the procedure
CALL GetTotalOrder();    
-- return 326

-- drop the stored procedure
-- DROP PROCEDURE IF EXISTS GetTotalOrder;




-- 2. Create a procedure to check if a customer is "PLATINUM" or "NOT PLATINUM"
-- where PLATINUM are the cutomers with credit limit higher than 50,000

CREATE PROCEDURE GetCustomerLevel(
    IN pCustomerNumber INT,
    OUT pCustomerLevel VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL(10, 2) DEFAULT 0;

    SELECT creditlimit 
    INTO credit
    FROM Customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = "PLATINUM";
    ELSEIF credit <= 50000 AND credit > 10000 THEN
        SET pCustomerLevel = "GOLD";
    ELSE
        SET pCustomerLevel = "SILVER";
    END IF;
END


CALL GetCustomerLevel(447, @level);
SELECT @level;


DROP PROCEDURE IF EXISTS GetCustomerLevel;


-- 2. Create a procedure to return the delivery status given an order number as follows:
--    IF waiting day >= 5, status = Very Late
--    IF waiting day >1 and <5, status = Late 
--    IF waiting day = 0, status = On time
--    ELSE status = No Info

CREATE PROCEDURE GetDeliveryStatus(
	IN pOrderNumber INT,
    OUT pDeliveryStatus VARCHAR(100)
)
BEGIN
	DECLARE waitingDay INT DEFAULT 0;

    SELECT 
		DATEDIFF(requiredDate, shippedDate)
	INTO waitingDay
	FROM orders
    WHERE orderNumber = pOrderNumber;
    
    CASE 
		WHEN waitingDay = 0 THEN 
			SET pDeliveryStatus = 'On Time';
        WHEN waitingDay >= 1 AND waitingDay < 5 THEN
			SET pDeliveryStatus = 'Late';
		WHEN waitingDay >= 5 THEN
			SET pDeliveryStatus = 'Very Late';
		ELSE
			SET pDeliveryStatus = 'No Information';
	END CASE;	
END


CALL GetDeliveryStatus(10100,@delivery);
SELECT @delivery;


DROP PROCEDURE IF EXISTS GetDeliveryStatus;





-- 4. Create a procedure to return all employees emails in concatenated form seperated by ";"

CREATE PROCEDURE createEmailList (
	INOUT emailList TEXT
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE emailAddress varchar(100) DEFAULT "";

	-- declare cursor for employee email
	DEClARE curEmail 
		CURSOR FOR 
			SELECT email FROM employees;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curEmail;

	getEmail: LOOP
		FETCH curEmail INTO emailAddress;
		IF finished = 1 THEN 
			LEAVE getEmail;
		END IF;
		-- build email list
		SET emailList = CONCAT(emailAddress,"; ",emailList);
	END LOOP getEmail;
	CLOSE curEmail;

END

SET @emailList = ""; 
CALL createEmailList(@emailList); 
SELECT @emailList;

-- DROP PROCEDURE IF EXISTS createEmailList;


-- show all avaialble procedures for a database
SHOW PROCEDURE STATUS
WHERE Db = 'classicmodels';

-- OR
SELECT 
    routine_name
FROM
    information_schema.routines
WHERE
    routine_type = 'PROCEDURE'
        AND routine_schema = 'classicmodels';
