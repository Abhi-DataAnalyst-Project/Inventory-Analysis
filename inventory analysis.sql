USE inventory;
SELECT * FROM customer;
SELECT *FROM inventory;
SELECT * FROM plugelectronics;
SELECT * FROM store;

-- 1) product type wise sales--

Select Product_type, SUM(price * quantity) as Total_sales From plugelectronics
GROUP BY product_type
ORDER BY total_sales;

-- 2) total Cost --

Select ROUND(SUM(price * cost),2) AS total_cost FROM plugelectronics;

-- 3) Total Profit --

-- 4) ADD sales Column -- 

SELECT * FROM plugelectronics;

ALTER TABLE plugelectronics ADD COLUMN sales INT AFTER price;

SET SQL_SAFE_UPDATES = 0;

UPDATE plugelectronics
SET sales = price * quantity;

-- 5) ADD total cost column ---

ALTER TABLE plugelectronics ADD COLUMN total_cost INT AFTER sales;

UPDATE plugelectronics
SET total_cost = cost * quantity;

-- 6) ADD profit column --

ALTER TABLE plugelectronics ADD COLUMN profit INT AFTER total_cost;

UPDATE plugelectronics
SET profit = sales - total_cost;

-- 7) Calculatting Store wise sales --

SELECT store_name, SUM(sales) AS total_sales FROM plugelectronics
GROUP BY store_name
ORDER BY total_sales DESC;

-- 8) Calculatting Brand wise sales --

SELECT * FROM inventory;

SELECT product_brand, SUM(sales) AS total_sales FROM plugelectronics
JOIN inventory
USING (sku_number)
Group by product_brand
ORDER BY total_sales DESC;

-- 8) Calculatting Product wise gross profit % --

SELECT product_name, profit, ((sales - profit) / sales) * 100 AS gross_profit_margin
FROM plugelectronics;

-- 9) Calculatting Product in Inventory, out_of_stock, under_stock, over_stock --

ALTER TABLE inventory ADD COLUMN terget_inventory INT;
UPDATE inventory 
SET terget_inventory = 5 ;

ALTER TABLE inventory ADD COLUMN under_stock INT ;
UPDATE inventory
SET under_stock = terget_inventory - product_in_inventory;

ALTER TABLE inventory ADD COLUMN out_of_stock INT;
UPDATE inventory
SET out_of_stock = 
                   CASE WHEN product_in_inventory = 0
						THEN terget_inventory - product_in_inventory
                        ELSE 0
                        END;
					
ALTER TABLE inventory ADD COLUMN over_stock INT ;
UPDATE inventory
SET over_stock =
                CASE WHEN product_in_inventory > terget_inventory
                     THEN product_in_inventory - terget_inventory
                     ELSE 0
                     END;

SELECT * FROM inventory; 

SELECT product_name, SUM(Product_in_inventory), SUM(out_of_stock), SUM(under_stock), SUM(over_stock) FROM inventory
GROUP BY product_name;
                
-- 10) Calculatting  Inventory Value --

SELECT product_brand, SUM(price* product_in_inventory) AS inventory_value
FROM inventory
GROUP BY Product_Brand
ORDER BY inventory_value DESC;

-- 11) Region Wise Total sales,total profit, profit margin %, unique orders --

ALTER TABLE plugelectronics ADD COLUMN profit_margin int AFTER profit;
SET SQL_SAFE_UPDATES = 0;

UPDATE plugelectronics
SET profit_margin = ((sales-profit)/sales) *100;

SELECT store_region, SUM(sales) AS total_sales, SUM(profit) AS total_Profit,
AVG(profit_margin) AS profit_margin, COUNT(DISTINCT order_number) AS unique_orders FROM plugelectronics
GROUP BY store_region;

-- 12) Daily sales trend --

ALTER TABLE plugelectronics MODIFY COLUMN date TIMESTAMP;

SELECT DAYNAME(date) AS day_name, SUM(sales) AS total_sales FROM plugelectronics
GROUP BY day_name
ORDER BY total_sales DESC;

-- 14) YTD sales --

SELECT YEAR(date) AS year, SUM(sales) AS total_sales,
SUM(sales) AS YTD_sales
FROM plugelectronics
WHERE date <= current_date()
GROUP BY year;

-- 15) QTD sales --

SELECT QUARTER(date) AS quarter, 
SUM(sales) AS QTD_sales
FROM plugelectronics
WHERE date <= current_date()
GROUP BY quarter;

-- 16) MTD sales --

SELECT MONTHNAME(date) AS month, 
SUM(sales) AS MTD_sales
FROM plugelectronics
WHERE date <= current_date()
GROUP BY month;

-- 17) Total Sales --
SELECT SUM(sales) AS Total_sales 
from plugelectronics;

-- 18) Total Profit --
SELECT SUM(profit) AS total_profit
FROM plugelectronics;

-- ================================================================================================================= --