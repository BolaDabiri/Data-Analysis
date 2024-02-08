-- All the data we're working with: (Company sales data for the year 2019)

SELECT
	*
FROM
	`sales data`
ORDER BY `Order Date` ASC, `Order Time` ASC;

-- Most Ordered Products (Annual)

SELECT
	Product,
    SUM(`Quantity Ordered`) `Total Quantity`
FROM
	`sales data`
GROUP BY
	Product
ORDER BY 
	`Total Quantity` DESC;
    
-- Highest Grossing Products (Annual)

SELECT
	Product,
    SUM(Sales) `Total Sales`
FROM
	`sales data`
GROUP BY
	Product
ORDER BY 
	`Total Sales` DESC;
    
-- Highest Grossing Product (Monthly)

WITH Monthly_product_sales AS (
	SELECT
		Month,
		Product,
		SUM(Sales) `Total Sales`
	FROM
		`sales data`
	GROUP BY Month, Product
	ORDER BY Month, `Total Sales`
	)
    SELECT
		Month,
        Product,
        `Total Sales`
	FROM (
		SELECT
			*,
            DENSE_RANK() OVER (
				PARTITION BY Month
                ORDER BY `Total Sales` DESC) AS `Rank`
		FROM
			Monthly_product_sales
    ) AS Ranked_Monthly_product_sales
    WHERE
		`Rank` = 1;
        
-- Top 5 Most Ordered Products (Monthly)

WITH Monthly_product_orders AS (
	SELECT
		Month,
		Product,
		SUM(`Quantity Ordered`) `Total Orders`
	FROM
		`sales data`
	GROUP BY Month, Product
	ORDER BY Month, `Total Orders`
	)
    SELECT
		*
	FROM (
		SELECT
			*,
            DENSE_RANK() OVER (
				PARTITION BY Month
                ORDER BY `Total Orders` DESC) AS `Rank`
		FROM
			Monthly_product_orders
    ) AS Ranked_Monthly_product_orders
    WHERE
		`Rank` BETWEEN 1 AND 5;
        
-- Top 5 Most Ordered Products (Monthly) [Pivot]

WITH Monthly_product_orders AS (
	SELECT
		Month,
		Product,
		SUM(`Quantity Ordered`) `Total Orders`
	FROM
		`sales data`
	GROUP BY Month, Product
	ORDER BY Month, `Total Orders`
	)
    SELECT
		`Order Rank`,
        MAX(CASE WHEN Month = 'January' THEN Product END) AS 'January',
        MAX(CASE WHEN Month = 'February' THEN Product END) AS 'February',
        MAX(CASE WHEN Month = 'March' THEN Product END) AS 'March',
        MAX(CASE WHEN Month = 'April' THEN Product END) AS 'April',
        MAX(CASE WHEN Month = 'May' THEN Product END) AS 'May',
        MAX(CASE WHEN Month = 'June' THEN Product END) AS 'June',
        MAX(CASE WHEN Month = 'July' THEN Product END) AS 'July',
        MAX(CASE WHEN Month = 'August' THEN Product END) AS 'August',
        MAX(CASE WHEN Month = 'September' THEN Product END) AS 'September',
        MAX(CASE WHEN Month = 'October' THEN Product END) AS 'October',
        MAX(CASE WHEN Month = 'November' THEN Product END) AS 'November',
        MAX(CASE WHEN Month = 'December' THEN Product END) AS 'December'
	FROM (
		SELECT
			*,
            DENSE_RANK() OVER (
				PARTITION BY `Month`
                ORDER BY `Total Orders` DESC) AS `Order Rank`
			FROM
				Monthly_product_orders
			) AS Ranked_Monthly_product_orders
	GROUP BY `Order Rank`
    HAVING `Order Rank` BETWEEN 1 AND 5;
    
-- Top 5 Most Ordered Products (Per Weekday)

WITH Daily_product_orders AS (
	SELECT
		`Weekday`,
		Product,
		SUM(`Quantity Ordered`) `Total Orders`
	FROM
		`sales data`
	GROUP BY `Weekday`, Product
	ORDER BY `Weekday`, `Total Orders`
	)
    SELECT
		`Order Rank`,
        MAX(CASE WHEN `Weekday` = 'Sunday' THEN Product END) AS 'Sunday',
        MAX(CASE WHEN `Weekday` = 'Monday' THEN Product END) AS 'Monday',
        MAX(CASE WHEN `Weekday` = 'Tuesday' THEN Product END) AS 'Tuesday',
        MAX(CASE WHEN `Weekday` = 'Wednesday' THEN Product END) AS 'Wednesday',
        MAX(CASE WHEN `Weekday` = 'Thursday' THEN Product END) AS 'Thursday',
        MAX(CASE WHEN `Weekday` = 'Friday' THEN Product END) AS 'Friday',
        MAX(CASE WHEN `Weekday` = 'Saturday' THEN Product END) AS 'Saturday'
	FROM (
		SELECT
			*,
            DENSE_RANK() OVER (
				PARTITION BY `Weekday`
                ORDER BY `Total Orders` DESC) AS `Order Rank`
			FROM
				Daily_product_orders
			) AS Ranked_Daily_product_orders
	GROUP BY `Order Rank`
    HAVING `Order Rank` BETWEEN 1 AND 5;

-- Top 5 Most Grossing Products (Monthly)

WITH Monthly_product_sales AS (
	SELECT
		Month,
		Product,
		SUM(`Sales`) `Total Sales`
	FROM
		`sales data`
	GROUP BY Month, Product
	ORDER BY Month, `Total Sales`
	)
    SELECT
		`Sales Rank`,
        MAX(CASE WHEN Month = 'January' THEN Product END) AS 'January',
        MAX(CASE WHEN Month = 'February' THEN Product END) AS 'February',
        MAX(CASE WHEN Month = 'March' THEN Product END) AS 'March',
        MAX(CASE WHEN Month = 'April' THEN Product END) AS 'April',
        MAX(CASE WHEN Month = 'May' THEN Product END) AS 'May',
        MAX(CASE WHEN Month = 'June' THEN Product END) AS 'June',
        MAX(CASE WHEN Month = 'July' THEN Product END) AS 'July',
        MAX(CASE WHEN Month = 'August' THEN Product END) AS 'August',
        MAX(CASE WHEN Month = 'September' THEN Product END) AS 'September',
        MAX(CASE WHEN Month = 'October' THEN Product END) AS 'October',
        MAX(CASE WHEN Month = 'November' THEN Product END) AS 'November',
        MAX(CASE WHEN Month = 'December' THEN Product END) AS 'December'
	FROM (
		SELECT
			*,
            DENSE_RANK() OVER (
				PARTITION BY `Month`
                ORDER BY `Total Sales` DESC) AS `Sales Rank`
			FROM
				Monthly_product_sales
			) AS Ranked_Monthly_product_sales
	GROUP BY `Sales Rank`
    HAVING `Sales Rank` BETWEEN 1 AND 5;

-- Top 5 Most Grossing Products (Per Weekday)

WITH Daily_product_sales AS (
	SELECT
		`Weekday`,
		Product,
		SUM(`Sales`) `Total Sales`
	FROM
		`sales data`
	GROUP BY `Weekday`, Product
	ORDER BY `Weekday`, `Total Sales`
	)
    SELECT
		`Sales Rank`,
        MAX(CASE WHEN `Weekday` = 'Sunday' THEN Product END) AS 'Sunday',
        MAX(CASE WHEN `Weekday` = 'Monday' THEN Product END) AS 'Monday',
        MAX(CASE WHEN `Weekday` = 'Tuesday' THEN Product END) AS 'Tuesday',
        MAX(CASE WHEN `Weekday` = 'Wednesday' THEN Product END) AS 'Wednesday',
        MAX(CASE WHEN `Weekday` = 'Thursday' THEN Product END) AS 'Thursday',
        MAX(CASE WHEN `Weekday` = 'Friday' THEN Product END) AS 'Friday',
        MAX(CASE WHEN `Weekday` = 'Saturday' THEN Product END) AS 'Saturday'
	FROM (
		SELECT
			*,
            DENSE_RANK() OVER (
				PARTITION BY `Weekday`
                ORDER BY `Total Sales` DESC) AS `Sales Rank`
			FROM
				Daily_product_sales
			) AS Ranked_Daily_product_sales
	GROUP BY `Sales Rank`
    HAVING `Sales Rank` BETWEEN 1 AND 5;

-- Most Ordered Product Per REGION (State/City)

WITH Orders_per_state AS (	
    SELECT
		State,
		Product,
		SUM(`Quantity Ordered`) AS `Total Orders`
	FROM
		`sales data`
	GROUP BY State, Product
	ORDER BY State
    )
		SELECT
			State,
            Product,
            `Total Orders`
		FROM (
			SELECT
				*,
                DENSE_RANK() OVER (
					PARTITION BY State
                    ORDER BY `Total Orders` DESC) AS `Rank`
			FROM
				Orders_per_state) AS Ranked_state_orders
		WHERE `Rank` = 1;

-- Highest Grossing Product Per REGION (State/City)

WITH Sales_per_state AS (	
    SELECT
		State,
		Product,
		SUM(`Sales`) AS `Total Sales`
	FROM
		`sales data`
	GROUP BY State, Product
	ORDER BY State
    )
		SELECT
			State,
            Product,
            `Total Sales`
		FROM (
			SELECT
				*,
                DENSE_RANK() OVER (
					PARTITION BY State
                    ORDER BY `Total Sales` DESC) AS `Rank`
			FROM
				Sales_per_state) AS Ranked_state_sales
		WHERE `Rank` = 1;

-- Top 3 Most Ordered Products Per REGION (State/City)

WITH City_orders AS (
	SELECT
		City,
		Product,
		SUM(`Quantity Ordered`) `Total Orders`
	FROM
		`sales data`
	GROUP BY City, Product
	ORDER BY City, `Total Orders`
	)
    SELECT
		`Order Rank`,
        MAX(CASE WHEN City = 'San Francisco' THEN Product END) AS 'San Francisco',
        MAX(CASE WHEN City = 'New York City' THEN Product END) AS 'New York City',
        MAX(CASE WHEN City = 'Seattle' THEN Product END) AS 'Seattle',
        MAX(CASE WHEN City = 'Los Angeles' THEN Product END) AS 'Los Angeles',
        MAX(CASE WHEN City = 'Boston' THEN Product END) AS 'Boston',
        MAX(CASE WHEN City = 'Atlanta' THEN Product END) AS 'Atlanta',
        MAX(CASE WHEN City = 'Portland' THEN Product END) AS 'Portland',
        MAX(CASE WHEN City = 'Dallas' THEN Product END) AS 'Dallas',
        MAX(CASE WHEN City = 'Austin' THEN Product END) AS 'Austin'
	FROM (
		SELECT
			*,
            DENSE_RANK() OVER (
				PARTITION BY City
                ORDER BY `Total Orders` DESC) AS `Order Rank`
			FROM
				City_orders
			) AS Ranked_City_orders
	GROUP BY `Order Rank`
    HAVING `Order Rank` BETWEEN 1 AND 3;

-- Top 3 Highest Grossing Products Per REGION (State/City)

WITH City_sales AS (
	SELECT
		City,
		Product,
		SUM(`Sales`) `Total Sales`
	FROM
		`sales data`
	GROUP BY City, Product
	ORDER BY City, `Total Sales`
	)
    SELECT
		`Sales Rank`,
        MAX(CASE WHEN City = 'San Francisco' THEN Product END) AS 'San Francisco',
        MAX(CASE WHEN City = 'New York City' THEN Product END) AS 'New York City',
        MAX(CASE WHEN City = 'Seattle' THEN Product END) AS 'Seattle',
        MAX(CASE WHEN City = 'Los Angeles' THEN Product END) AS 'Los Angeles',
        MAX(CASE WHEN City = 'Boston' THEN Product END) AS 'Boston',
        MAX(CASE WHEN City = 'Atlanta' THEN Product END) AS 'Atlanta',
        MAX(CASE WHEN City = 'Portland' THEN Product END) AS 'Portland',
        MAX(CASE WHEN City = 'Dallas' THEN Product END) AS 'Dallas',
        MAX(CASE WHEN City = 'Austin' THEN Product END) AS 'Austin'
	FROM (
		SELECT
			*,
            DENSE_RANK() OVER (
				PARTITION BY City
                ORDER BY `Total Sales` DESC) AS `Sales Rank`
			FROM
				City_sales
			) AS Ranked_City_sales
	GROUP BY `Sales Rank`
    HAVING `Sales Rank` BETWEEN 1 AND 3;

-- Busiest Day Per REGION (State/City)

WITH State_orders_per_day AS (
	SELECT
		State,
        Weekday,
        SUM(`Quantity Ordered`) AS `Total Orders`
	FROM
		`sales data`
	GROUP BY State, Weekday
	)
    SELECT
		State,
        Weekday,
        `Total Orders`
	FROM
		(SELECT 
			*,
            DENSE_RANK() OVER (
				PARTITION BY State
                ORDER BY `Total Orders` DESC) AS `Rank`
		FROM
			State_orders_per_day) AS Ranked_state_orders
	WHERE `Rank` = 1;

-- Busiest Hour Per Day

WITH hourly_orders AS (
	SELECT
		Weekday,
        Hour,
        SUM(`Quantity Ordered`) AS `Total Orders`
	FROM
		`sales data`
	GROUP BY Weekday, Hour
	)
    SELECT
        Weekday,
        Hour,
        `Total Orders`
	FROM
		(SELECT 
			*,
            DENSE_RANK() OVER (
				PARTITION BY Weekday
                ORDER BY `Total Orders` DESC) AS `Rank`
		FROM
			hourly_orders) AS Ranked_hourly_orders
	WHERE `Rank` = 1;