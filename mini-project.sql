DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(10) NOT NULL UNIQUE
);
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyễn Văn A', 'a@gmail.com', '0900000001'),
('Trần Thị B',  'b@gmail.com', '0900000002'),
('Lê Văn C',    'c@gmail.com', '0900000003'),
('Phạm Thị D',  'd@gmail.com', '0900000004');
INSERT INTO categories (category_name) VALUES
('Điện thoại'),
('Laptop'),
('Phụ kiện');
INSERT INTO products (product_name, price, category_id) VALUES
('iPhone 15',         25000000, 1),
('Samsung S23',       22000000, 1),
('MacBook Air M2',    28000000, 2),
('Dell XPS 13',       26000000, 2),
('AirPods Pro',        5500000, 3),
('Chuột Logitech',     1200000, 3);
INSERT INTO orders (customer_id, status) VALUES
(1, 'COMPLETED'),
(1, 'PENDING'),
(2, 'COMPLETED'),
(3, 'COMPLETED'),
(3, 'CANCELLED');
INSERT INTO order_items (order_id, product_id, quantity) VALUES
-- Đơn hàng 1
(1, 1, 1),
(1, 5, 2),

-- Đơn hàng 2
(2, 2, 1),

-- Đơn hàng 3
(3, 3, 1),
(3, 6, 1),

-- Đơn hàng 4
(4, 4, 1),
(4, 5, 1);
SELECT *
FROM categories;
SELECT *
FROM orders
WHERE status = 'COMPLETED';
SELECT *
FROM products
ORDER BY price DESC;
SELECT *
FROM products
ORDER BY price DESC
LIMIT 5 OFFSET 2;
SELECT p.product_id,
       p.product_name,
       p.price,
       c.category_name
FROM products p
JOIN categories c
ON p.category_id = c.category_id;
SELECT o.order_id,
       o.order_date,
       c.customer_name,
       o.status
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;
SELECT o.order_id,
       SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id;
SELECT c.customer_id,
       c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
SELECT c.customer_id,
       c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;
SELECT c.category_name,
       AVG(p.price) AS avg_price,
       MIN(p.price) AS min_price,
       MAX(p.price) AS max_price
FROM categories c
JOIN products p
ON c.category_id = p.category_id
GROUP BY c.category_name;
SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
);
SELECT order_id,
       SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
ORDER BY total_quantity DESC
LIMIT 1;
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category_id = (
    SELECT category_id
    FROM products
    GROUP BY category_id
    ORDER BY AVG(price) DESC
    LIMIT 1
);
SELECT customer_id,
       SUM(total_quantity) AS total_products
FROM (
    SELECT o.customer_id,
           SUM(oi.quantity) AS total_quantity
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.customer_id
) t
GROUP BY customer_id;
SELECT *
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
);