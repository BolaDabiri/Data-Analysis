-- First off, let's see what we're dealing with

SELECT
	*
FROM
	`sales data`
LIMIT 1000;

-- Renaming "MyUnknownColumn" which contains Serial Numbers

ALTER TABLE
	`sales data`
RENAME COLUMN
	MyUnknownColumn TO `S/N`;

-- Splitting Date and Time info under "Order Date" column into distinct columns

	-- First, create new column to hold the time information
    
    ALTER TABLE
		`sales data`
	ADD `Order Time` time;
    
    -- Fill new column with time information
    
    UPDATE
		`sales data`
	SET
		`Order Time` = time_format(TIME(`Order Date`), '%H:%i:%s');
        
	-- Remove time info from "Order Date" column and reformat Order Date
    
    UPDATE
		`sales data`
	SET
		`Order Date` = str_to_date(date_format(DATE(`Order Date`), '%d-%m-%Y'), '%d-%m-%Y');
        
	-- Creating and populating new column with "Weekday" info
    
    ALTER TABLE
		`sales data`
	ADD COLUMN Weekday varchar(10);
    
    UPDATE
		`sales data`
	SET
		Weekday = DAYNAME(str_to_date(`Order Date`, '%d-%m-%Y'));
					
-- Changing numerical values under "Month" column to Month Names

ALTER TABLE
	`sales data` 
MODIFY COLUMN 
	Month varchar(10);
    
UPDATE
	`sales data`
SET
	Month = monthname(`Order Date`);
    
-- Splitting up Purchase Address Info into specific columns

	-- Creating new columns for the new info
    
	ALTER TABLE
		`sales data`
	ADD COLUMN Street varchar(255),
	ADD COLUMN State varchar(5),
	ADD COLUMN `ZIP Code` varchar(10);

	-- Updating the Street data
    
	UPDATE
		`sales data`
	SET
		Street = substring(`Purchase Address`, 1, LOCATE(',', `Purchase Address`)-1);
  
	-- Updating the ZIP Code data
   
	UPDATE
		`sales data`
	SET
		`ZIP Code` = TRIM(substring_index(`Purchase Address`, ' ', -1));
        
	-- Updating State data
    
	UPDATE
		`sales data`
	SET
		State = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`Purchase Address`, ',', -1), ' ', 2));

	-- Extracting City info (if it wasn't already provided in dataset)
    
    ALTER TABLE
		`sales data`
	ADD City varchar(255);
    
    UPDATE
		`sales data`
	SET
		City = substring(`Purchase Address`, LOCATE(',', `Purchase Address`)+2, LOCATE(',', `Purchase Address`, -1)-1);

-- Dropping Columns that are no longer needed

ALTER TABLE
	`sales data`
DROP COLUMN `Purchase Address`;

-- "Purchase Address" column can be re-added by running the following queries:
	
    -- First, creating the column "Purchase Address" in the table
    
    ALTER TABLE
		`sales data`
	ADD COLUMN `Purchase Address` varchar(255);
    
    -- Then, populate the new column with concatenated info from the other address columns
    
    UPDATE
		`sales data`
	SET
		`Purchase Address` = CONCAT(Street, ', ', City, ', ', State, ' ', `ZIP Code`);
        
-- Dealing with duplicates

	-- Identify duplicate records
        
	SELECT 
		`Order ID`, Product, `Order Date`, `Order Time`, COUNT(*)
	FROM
		`sales data`
	GROUP BY
		`Order ID`, Product, `Order Date`, `Order Time`
	HAVING 
		COUNT(*) > 1;
        
	-- Delete duplicate records
    
	/* This method assigns unique IDs to each record,
	then stores the ID of each unique record (i.e. one occurrence of duplicate records) in a temporary table,
	afterwards, all records without a matching id in the temporary table are deleted from our original table */
    
    ALTER TABLE
		`sales data`
	ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;
    
    CREATE TEMPORARY TABLE min_ids AS
		SELECT
			MIN(id) AS id
		FROM
			`sales data`
		GROUP BY
			`Order ID`, Product, `Order Date`, `Order Time`;
            
	DELETE
	FROM
		`sales data`
	WHERE
		id NOT IN (
			SELECT
				id
			FROM
				min_ids);
			
ALTER TABLE
	`sales data`
DROP COLUMN id,
DROP COLUMN `S/N`;

-- `S/N` is dropped because it serves no purpose, seeing as it holds no unique identifier or information

-- Checking for null values: substitute column name for column of interest or consideration

SELECT
	*
FROM
	`sales data`
WHERE Product is null;

-- `sales data` table is ready for Exploratory Data Analysis AND Visualisation!