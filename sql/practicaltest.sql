DROP DATABASE IF EXISTS practicaltest;
CREATE DATABASE practicaltest;
USE practicaltest;

SET @seed = 5;
SET @customers = 20000;
SET @orders = 30000;
SET @employees_per_branch = 10;

CREATE TABLE models (
    model_name VARCHAR(50) PRIMARY KEY,
    base_cost DECIMAL(8,2) NOT NULL,
    average_lead_time INTEGER NOT NULL
);

INSERT INTO models (model_name, base_cost, average_lead_time) VALUES
('City', 10000.00, 35),
('Family', 18000.00, 40),
('Luxury', 30000.00, 50),
('Sport', 32000.00, 50);

CREATE TABLE engines (
    engine_designation VARCHAR(50) PRIMARY KEY,
    capacity INTEGER NOT NULL,
    fuel_type VARCHAR(10) NOT NULL
);

INSERT INTO engines (engine_designation, capacity, fuel_type) VALUES
('1.0i', 1000, 'Petrol'),
('1.5ti', 1500, 'Petrol'),
('1.8i', 1800, 'Petrol'),
('1.8d', 1800, 'Diesel'),
('2.0ti', 2000, 'Petrol'),
('2.0d', 2000, 'Diesel'),
('3.0i', 3000, 'Petrol'),
('3.0d', 3000, 'Diesel'),
('4.0V8i', 4000, 'Petrol');

CREATE TABLE models_engines_intersect (
    model_name VARCHAR(50) NOT NULL,
    engine_designation VARCHAR(50) NOT NULL,
    additional_cost DECIMAL(6,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (model_name, engine_designation),
    FOREIGN KEY (model_name) REFERENCES models (model_name),
    FOREIGN KEY (engine_designation) REFERENCES engines (engine_designation)    
);

INSERT INTO models_engines_intersect (model_name, engine_designation, additional_cost) VALUES
('City', '1.0i', 0),
('City', '1.5ti', 2500),
('Family', '1.8i', 0),
('Family', '1.8d', 0),
('Family', '1.5ti', 1000),
('Family', '2.0ti', 4000),
('Family', '2.0d', 2000),
('Luxury', '2.0ti', 2000),
('Luxury', '2.0d', 0),
('Luxury', '3.0i', 6000),
('Luxury', '3.0d', 8000),
('Sport', '3.0i', 0),
('Sport', '4.0V8i', 7500);

CREATE TABLE trims (
    trim_name VARCHAR(50) PRIMARY KEY,
    additional_cost DECIMAL(6,2) NOT NULL DEFAULT 0
);

INSERT INTO trims (trim_name, additional_cost) VALUES
('Basic', 0), 
('Plus', 2000), 
('Ultra', 5000);

CREATE TABLE trim_equipment (
    trim_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    wheel_type VARCHAR(50) NOT NULL,
    infotainment_type VARCHAR(50) NOT NULL,
    headlight_type VARCHAR(50) NOT NULL,
    upholstery_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (trim_name, start_date),
    FOREIGN KEY (trim_name) REFERENCES trims (trim_name)
);

INSERT INTO trim_equipment (trim_name, start_date, end_date, wheel_type, infotainment_type, headlight_type, upholstery_type) VALUES
('Basic', '2010-01-01', NULL, '16 inch', 'CD/Radio', 'Halogen', 'Cloth'),
('Plus', '2010-01-01', '2013-12-31', '17 inch', '6 CD Changer', 'Halogen', 'Cloth'),
('Plus', '2014-01-01', NULL, '17 inch', '6 inch Bluetooth/GPS', 'Halogen', 'Cloth'),
('Ultra', '2010-01-01', '2016-05-31', '19 inch', '6 inch Bluetooth/GPS', 'Xenon', 'Leather'),
('Ultra', '2016-06-01', NULL, '19 inch', '8 inch Bluetooth/GPS', 'LED', 'Leather');

CREATE TABLE customers (
    customer_number INTEGER PRIMARY KEY AUTO_INCREMENT,
    forename VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    telephone_number VARCHAR(15) NOT NULL
);

DROP FUNCTION IF EXISTS generate_fname;
DELIMITER $$
CREATE FUNCTION generate_fname() RETURNS VARCHAR(50)
BEGIN
	RETURN ELT(FLOOR(1 + (RAND() * (100-1))), "James","Mary","John","Patricia","Robert","Linda","Michael","Barbara","William","Elizabeth","David","Jennifer","Richard","Maria","Charles","Susan","Joseph","Margaret","Thomas","Dorothy","Christopher","Lisa","Daniel","Nancy","Paul","Karen","Mark","Betty","Donald","Helen","George","Sandra","Kenneth","Donna","Steven","Carol","Edward","Ruth","Brian","Sharon","Ronald","Michelle","Anthony","Laura","Kevin","Sarah","Jason","Kimberly","Matthew","Deborah","Gary","Jessica","Timothy","Shirley","Jose","Cynthia","Larry","Angela","Jeffrey","Melissa","Frank","Brenda","Scott","Amy","Eric","Anna","Stephen","Rebecca","Andrew","Virginia","Raymond","Kathleen","Gregory","Pamela","Joshua","Martha","Jerry","Debra","Dennis","Amanda","Walter","Stephanie","Patrick","Carolyn","Peter","Christine","Harold","Marie","Douglas","Janet","Henry","Catherine","Carl","Frances","Arthur","Ann","Ryan","Joyce","Roger","Diane");
END$$

DELIMITER ;

DROP FUNCTION IF EXISTS generate_lname;
DELIMITER $$
CREATE FUNCTION generate_lname() RETURNS VARCHAR(50)
BEGIN
	RETURN ELT(FLOOR(1 + (RAND() * (100-1))), "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes");
END$$
DELIMITER ;

CREATE OR REPLACE VIEW generator_16
AS SELECT 0 n UNION ALL SELECT 1  UNION ALL SELECT 2  UNION ALL 
   SELECT 3   UNION ALL SELECT 4  UNION ALL SELECT 5  UNION ALL
   SELECT 6   UNION ALL SELECT 7  UNION ALL SELECT 8  UNION ALL
   SELECT 9   UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
   SELECT 12  UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL 
   SELECT 15;

CREATE OR REPLACE VIEW generator_256 AS 
SELECT ( ( hi.n << 4 ) | lo.n ) AS n
FROM generator_16 lo, generator_16 hi;

CREATE OR REPLACE VIEW generator_4k AS 
SELECT ( ( hi.n << 8 ) | lo.n ) AS n
FROM generator_256 lo, generator_16 hi;

CREATE OR REPLACE VIEW generator_64k AS 
SELECT ( ( hi.n << 8 ) | lo.n ) AS n
FROM generator_256 lo, generator_256 hi;

CREATE OR REPLACE VIEW generator_1m AS 
SELECT ( ( hi.n << 16 ) | lo.n ) AS n
FROM generator_64k lo, generator_16 hi;

INSERT INTO customers (forename, surname, telephone_number) 
SELECT generate_fname(), generate_lname(), RAND(@seed)
FROM generator_1m
WHERE n < @customers;

CREATE TABLE branches (
    branch_name VARCHAR(50) PRIMARY KEY,
    postcode VARCHAR(50) NOT NULL
);

INSERT INTO branches (branch_name, postcode) VALUES
('York', 'YO12 2HJ'),
('London', 'SW11 3LJ'),
('Glasgow', 'G3 5FG');

CREATE TABLE employees (
    employee_number INTEGER PRIMARY KEY AUTO_INCREMENT,
    line_manager_number INTEGER,
    branch_name VARCHAR(50),
    forename VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    FOREIGN KEY (branch_name) REFERENCES branches (branch_name),
    FOREIGN KEY (line_manager_number) REFERENCES employees (employee_number)
);

INSERT INTO employees (branch_name, forename, surname)
SELECT branch_name, generate_fname(), generate_lname()
FROM branches 
JOIN generator_1m ON n < @employees_per_branch;


CREATE TABLE orders (
    order_number INTEGER PRIMARY KEY AUTO_INCREMENT,
    customer_number INTEGER NOT NULL,
    employee_number INTEGER NOT NULL,
    sale_price DECIMAL(8,2) NOT NULL,
    deposit DECIMAL(8,2) NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_number) REFERENCES customers (customer_number),
    FOREIGN KEY (employee_number) REFERENCES employees (employee_number)
);

INSERT INTO orders (customer_number, employee_number, sale_price, deposit, order_date) 
SELECT FLOOR(RAND(@seed) * @customers) + 1,
       FLOOR(RAND(@seed) * (SELECT MAX(employee_number) FROM employees)) + 1,
       0, -- Will be updated once vehicle is known
       0,
       CURRENT_DATE - INTERVAL FLOOR(RAND(@seed) * DATEDIFF(CURRENT_DATE, '2010-01-01')) + 1 DAY
FROM generator_1m
WHERE n < @orders;
       

CREATE TABLE ordered_vehicles (
    vehicle_number INTEGER PRIMARY KEY AUTO_INCREMENT,
    order_number INTEGER NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    trim_name VARCHAR(50) NOT NULL,
    engine_designation VARCHAR(50) NOT NULL,
    colour VARCHAR(20) NOT NULL,
    expected_delivery_date DATE NOT NULL,
    actual_delivery_date DATE,
    FOREIGN KEY (order_number) REFERENCES orders (order_number),
    FOREIGN KEY (model_name) REFERENCES models (model_name),
    FOREIGN KEY (trim_name) REFERENCES trims (trim_name),
    FOREIGN KEY (engine_designation) REFERENCES engines (engine_designation)
);

SET @n = 0;

INSERT INTO ordered_vehicles (order_number, model_name, trim_name, engine_designation, colour, expected_delivery_date, actual_delivery_date) 
SELECT @n := @n + 1, 
       model_name, 
       trim_name, 
       engine_designation,
       ELT(FLOOR(1 + (RAND() * 6)), "Red", "White", "Black", "Silver", "Blue", "Grey") AS colour,
       CURRENT_DATE,
       NULL
FROM models_engines_intersect, trims, generator_1m
WHERE RAND() > 0.5
AND @n < @orders
UNION
SELECT CEIL(RAND() * @orders),
       model_name, 
       trim_name, 
       engine_designation,
       ELT(FLOOR(1 + (RAND() * 6)), "Red", "White", "Black", "Silver", "Blue", "Grey") AS colour,
       CURRENT_DATE,
       NULL
FROM models_engines_intersect, trims, generator_1m
WHERE RAND() > 0.5
AND (@n := @n + 1) < @orders * 1.25;


UPDATE orders o 
JOIN (SELECT v.order_number, SUM(m.base_cost + mei.additional_cost + t.additional_cost) AS total_base_cost
      FROM ordered_vehicles v
      JOIN models m ON v.model_name = m.model_name
      JOIN trims t ON v.trim_name = t.trim_name
      JOIN models_engines_intersect mei ON v.engine_designation = mei.engine_designation
                                        AND v.model_name = mei.model_name
      GROUP BY v.order_number) c ON o.order_number = c.order_number
SET o.sale_price = c.total_base_cost - (RAND() * total_base_cost * 0.15);

UPDATE orders 
SET deposit = sale_price * 0.1 * RAND();

UPDATE ordered_vehicles v
JOIN models m ON v.model_name = m.model_name
JOIN orders o ON o.order_number = v.order_number
SET expected_delivery_date = order_date + INTERVAL average_lead_time + FLOOR((RAND() - 0.5) * 14) DAY;

UPDATE ordered_vehicles 
SET actual_delivery_date = IF(RAND() > 0.8, expected_delivery_date + INTERVAL FLOOR(RAND() * 28) DAY, expected_delivery_date);

CREATE TABLE invoices (
    invoice_number INTEGER PRIMARY KEY AUTO_INCREMENT,
    order_number INTEGER NOT NULL,
    invoice_value DECIMAL(8,2) NOT NULL,
    settlement_date DATE,
    FOREIGN KEY (order_number) REFERENCES orders (order_number)
);

INSERT INTO invoices (order_number, invoice_value, settlement_date)
SELECT o.order_number,
       sale_price - deposit,
       IF(RAND() < 0.95, MAX(actual_delivery_date) + INTERVAL FLOOR(RAND() * 28) DAY, NULL) 
FROM orders o
JOIN ordered_vehicles v ON o.order_number = v.order_number
GROUP BY o.order_number
HAVING RAND() > 0.1;

DROP VIEW IF EXISTS generator_16;
DROP VIEW IF EXISTS generator_256;
DROP VIEW IF EXISTS generator_4k;
DROP VIEW IF EXISTS generator_64k;
DROP VIEW IF EXISTS generator_1m;
DROP FUNCTION IF EXISTS generate_fname;
DROP FUNCTION IF EXISTS generate_lname;