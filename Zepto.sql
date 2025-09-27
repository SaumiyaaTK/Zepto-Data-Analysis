drop table if exists zepto;

create table zepto(
sku_id Serial PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(8,2),
availableQuantity INTEGER,
discountSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
)

--Data Exploration

--Count of rows
SELECT COUNT(*) FROM zepto;

--Sample Data
SELECT * FROM zepto
LIMIT 10;

--Null values
SELECT * FROM zepto
WHERE name is NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
discountSellingPrice is NULL
OR
weightInGms is NULL
OR
availableQuantity is NULL
OR
outOfStock is NULL
OR
quantity is NULL;

--Different Product Categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--Products in Stock vs Out of Stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--Product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--Data Cleaning

--Price of Product=0
SELECT * FROM zepto
WHERE mrp=0 OR discountSellingPrice=0;

DELETE FROM zepto
WHERE mrp=0;

--Converting paise to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountSellingPrice=discountSellingPrice/100.0;

SELECT mrp, discountSellingPrice FROM zepto;

--BUSINESS INSIGHTS

--Top 10 Best value Products based on the Discount percentage
SELECT DIstinct name, mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--The Products with High MRP but Out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock=TRUE and mrp>300
ORDER BY mrp DESC;

--Estimated Revenue for each Category
SELECT category,
SUM(discountSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Products with MRP greater than Rs.500 and Discount less than 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC, discountPercent DESC;

--Top 5 categories offering Highest average discount percentage
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Price per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountSellingPrice,
ROUND(discountSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms>=100
ORDER BY price_per_gram;

--Grouping products into categories like Low, Medium and Bulk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms<1000 THEN 'Low'
     WHEN weightInGms<5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

--Total Inventory Weight Per category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;