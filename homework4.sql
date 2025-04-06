-- ЗАВДАННЯ 1: створення бази та таблиць
CREATE DATABASE IF NOT EXISTS LibraryManagement;
USE LibraryManagement;

CREATE TABLE authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  author_name VARCHAR(100)
);

CREATE TABLE genres (
  genre_id INT AUTO_INCREMENT PRIMARY KEY,
  genre_name VARCHAR(100)
);

CREATE TABLE books (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200),
  publication_year YEAR,
  author_id INT,
  genre_id INT,
  FOREIGN KEY (author_id) REFERENCES authors(author_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE borrowed_books (
  borrow_id INT AUTO_INCREMENT PRIMARY KEY,
  book_id INT,
  user_id INT,
  borrow_date DATE,
  return_date DATE,
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ЗАВДАННЯ 2: вставка тестових даних
INSERT INTO authors (author_name) VALUES ('Леся Українка');
INSERT INTO genres (genre_name) VALUES ('Драма');
INSERT INTO books (title, publication_year, author_id, genre_id)
VALUES ('Лісова пісня', 1911, 1, 1);
INSERT INTO users (username, email) VALUES ('ivan23', 'ivan@example.com');
INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date)
VALUES (1, 1, '2024-03-01', '2024-03-21');

-- ЗАВДАННЯ 3: INNER JOIN усіх таблиць теми 3
SELECT
  od.order_id,
  od.product_id,
  c.name AS customer_name,
  p.name AS product_name,
  cat.name AS category_name,
  e.first_name,
  s.name AS shipper_name,
  sup.name AS supplier_name
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers s ON o.shipper_id = s.id
INNER JOIN suppliers sup ON p.supplier_id = sup.id;

-- ЗАВДАННЯ 4.1: підрахунок кількості рядків
SELECT COUNT(*) FROM (
  SELECT
    od.order_id,
    od.product_id,
    c.name AS customer_name,
    p.name AS product_name,
    cat.name AS category_name,
    e.first_name,
    s.name AS shipper_name,
    sup.name AS supplier_name
  FROM order_details od
  INNER JOIN orders o ON od.order_id = o.id
  INNER JOIN customers c ON o.customer_id = c.id
  INNER JOIN products p ON od.product_id = p.id
  INNER JOIN categories cat ON p.category_id = cat.id
  INNER JOIN employees e ON o.employee_id = e.employee_id
  INNER JOIN shippers s ON o.shipper_id = s.id
  INNER JOIN suppliers sup ON p.supplier_id = sup.id
) AS joined_data;

-- ЗАВДАННЯ 4.2: LEFT JOIN замість INNER (кількість може змінитись)
-- ПОЯСНЕННЯ: При використанні LEFT JOIN кількість рядків або така сама, або більша, ніж при INNER JOIN.
-- Це відбувається тому, що LEFT JOIN включає всі записи з orders, навіть якщо у customers немає відповідності.
-- Якщо хоча б один order не має відповідного customer, то такий рядок врахується тільки в LEFT JOIN, а в INNER JOIN — ні.
SELECT COUNT(*) FROM orders o
LEFT JOIN customers c ON o.customer_id = c.id;

-- ЗАВДАННЯ 4.3: employee_id > 3 та ≤ 10
SELECT *
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE e.employee_id > 3 AND e.employee_id <= 10;

-- ЗАВДАННЯ 4.4-4.7: згруповані разом
SELECT cat.name AS category_name,
       COUNT(*) AS total_rows,
       AVG(od.quantity) AS avg_quantity
FROM order_details od
JOIN products p ON od.product_id = p.id
JOIN categories cat ON p.category_id = cat.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY total_rows DESC
LIMIT 4 OFFSET 1;
