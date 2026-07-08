-- ==============================================================================
-- E-Commerce Database Management System - MariaDB / MySQL Schema
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- ==============================================================================
-- 1. TABLE CREATION (Ordered by Dependencies)
-- ==============================================================================

CREATE TABLE Customer (
    CustomerId INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE NOT NULL,
    DateOfBirth DATE,
    Phone VARCHAR(15)
);

CREATE TABLE Seller (
    SellerId INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Total_Sales DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE Category (
    CategoryId INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL,
    Description TEXT
);

CREATE TABLE Product (
    ProductId INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Brand VARCHAR(100),
    MRP DECIMAL(10,2) NOT NULL,
    Stock INT DEFAULT 0,
    SellerId INT,
    CategoryId INT,
    FOREIGN KEY (SellerId) REFERENCES Seller(SellerId) ON DELETE SET NULL,
    FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId) ON DELETE SET NULL
);

CREATE TABLE Cart (
    CartId INT AUTO_INCREMENT PRIMARY KEY,
    CustomerId INT UNIQUE,
    ItemsTotal INT DEFAULT 0,
    GrandTotal DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON DELETE CASCADE
);

CREATE TABLE Orders (
    OrderId INT AUTO_INCREMENT PRIMARY KEY,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    ShippingDate DATETIME,
    OrderAmount DECIMAL(10,2) NOT NULL,
    CartId INT,
    CustomerId INT,
    DeliveryPincode VARCHAR(10),
    FOREIGN KEY (CartId) REFERENCES Cart(CartId) ON DELETE SET NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON DELETE CASCADE
);

CREATE TABLE OrderItem (
    OrderId INT,
    ProductId INT,
    MRP DECIMAL(10,2),
    Quantity INT,
    PRIMARY KEY (OrderId, ProductId),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Product(ProductId) ON DELETE CASCADE
);

CREATE TABLE Review (
    ReviewId INT AUTO_INCREMENT PRIMARY KEY,
    Ratings INT CHECK (Ratings >= 1 AND Ratings <= 5),
    Description TEXT,
    ProductId INT,
    CustomerId INT,
    FOREIGN KEY (ProductId) REFERENCES Product(ProductId) ON DELETE CASCADE,
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON DELETE CASCADE
);

CREATE TABLE Payment (
    PaymentId INT AUTO_INCREMENT PRIMARY KEY,
    PaymentMode VARCHAR(50),
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    OrderId INT UNIQUE,
    CustomerId INT,
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE,
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON DELETE CASCADE
);

-- ==============================================================================
-- 2. TRIGGERS
-- ==============================================================================

DELIMITER //

-- Trigger: Update stock when a payment is made successfully
CREATE TRIGGER After_Payment_Update_Stock
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    UPDATE Product p
    JOIN OrderItem oi ON p.ProductId = oi.ProductId
    SET p.Stock = p.Stock - oi.Quantity
    WHERE oi.OrderId = NEW.OrderId;
END; //

-- Trigger: Update Seller Total_Sales when a payment is made
CREATE TRIGGER After_Payment_Update_Seller_Sales
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    UPDATE Seller s
    JOIN Product p ON s.SellerId = p.SellerId
    JOIN OrderItem oi ON p.ProductId = oi.ProductId
    SET s.Total_Sales = s.Total_Sales + (oi.MRP * oi.Quantity)
    WHERE oi.OrderId = NEW.OrderId;
END; //

DELIMITER ;

-- ==============================================================================
-- 3. VIEWS
-- ==============================================================================

-- View: Getting sales by category of products
CREATE VIEW Sales_By_Category AS
SELECT c.CategoryName, SUM(oi.MRP * oi.Quantity) AS TotalRevenue, SUM(oi.Quantity) AS ItemsSold
FROM Category c
JOIN Product p ON c.CategoryId = p.CategoryId
JOIN OrderItem oi ON p.ProductId = oi.ProductId
JOIN Payment pay ON oi.OrderId = pay.OrderId
GROUP BY c.CategoryName;

-- ==============================================================================
-- 4. STORED PROCEDURES
-- ==============================================================================

DELIMITER //

-- Procedure: Get Details of a Customer
CREATE PROCEDURE GetCustomerDetails(IN cust_id INT)
BEGIN
    SELECT c.CustomerId, c.FirstName, c.LastName, c.Email, c.Phone, 
           TIMESTAMPDIFF(YEAR, c.DateOfBirth, CURDATE()) AS Age
    FROM Customer c
    WHERE c.CustomerId = cust_id;
END; //

-- Procedure: Get Order History for a Customer
CREATE PROCEDURE GetOrderHistory(IN cust_id INT)
BEGIN
    SELECT o.OrderId, o.OrderDate, o.OrderAmount, p.PaymentMode, p.PaymentDate
    FROM Orders o
    LEFT JOIN Payment p ON o.OrderId = p.OrderId
    WHERE o.CustomerId = cust_id
    ORDER BY o.OrderDate DESC;
END; //

DELIMITER ;

-- ==============================================================================
-- 5. SPECIFIC QUERIES (From requirements)
-- ==============================================================================

-- QUERY 1: Products with highest ratings for a given category (e.g., CategoryId = 1)
-- SELECT p.ProductName, AVG(r.Ratings) as AvgRating 
-- FROM Product p JOIN Review r ON p.ProductId = r.ProductId 
-- WHERE p.CategoryId = 1 GROUP BY p.ProductId ORDER BY AvgRating DESC LIMIT 1;

-- QUERY 2: Filter products by brand and price (e.g., Brand 'Samsung', Price < 50000)
-- SELECT * FROM Product WHERE Brand = 'Samsung' AND MRP < 50000;

-- QUERY 3: Total price for all products present in the cart
-- SELECT GrandTotal FROM Cart WHERE CartId = 1;

-- QUERY 4: Find the best seller of a particular product category
-- SELECT s.Name, s.Total_Sales FROM Seller s ORDER BY s.Total_Sales DESC LIMIT 1;

-- QUERY 5: List orders to be delivered at a particular pincode
-- SELECT * FROM Orders WHERE DeliveryPincode = '110001';

-- QUERY 9: List all orders whose payment mode is not CoD and yet to be delivered
-- SELECT o.* FROM Orders o JOIN Payment p ON o.OrderId = p.OrderId 
-- WHERE p.PaymentMode != 'CoD' AND o.ShippingDate IS NULL;

-- QUERY 10: List all orders of customers whose total amount is greater than 5000
-- SELECT * FROM Orders WHERE OrderAmount > 5000;

-- QUERY 12: List the seller who has the highest stock of a particular product
-- SELECT s.Name, p.ProductName, p.Stock FROM Seller s 
-- JOIN Product p ON s.SellerId = p.SellerId 
-- WHERE p.ProductName = 'Laptop' ORDER BY p.Stock DESC LIMIT 1;

-- QUERY 13: Compare products based on their ratings and reviews
-- SELECT p.ProductName, COUNT(r.ReviewId) as TotalReviews, AVG(r.Ratings) as AvgRating 
-- FROM Product p LEFT JOIN Review r ON p.ProductId = r.ProductId 
-- GROUP BY p.ProductId ORDER BY AvgRating DESC;
