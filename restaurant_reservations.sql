-- 1. Create a database named restaurant_reservations
CREATE DATABASE IF NOT EXISTS restaurants_reservations;

-- 2. Use the previously created database
USE restaurants_reservations;

-- MySQL Tables and Relationships

-- 1. Customers Table
CREATE TABLE IF NOT EXISTS customers (
    customerId INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    customerName VARCHAR(45) NOT NULL,
    contactInfo VARCHAR(200)  -- Stores email or phone number
);

-- 2. Reservations Table
CREATE TABLE IF NOT EXISTS reservations (
    reservationId INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    customerId INT NOT NULL,
    reservationTime DATETIME NOT NULL,
    numberOfGuests INT NOT NULL,
    specialRequests VARCHAR(200),
    FOREIGN KEY (customerId) REFERENCES customers(customerId)
);

-- 3. DiningPreferences Table
CREATE TABLE IF NOT EXISTS diningPreferences (
    preferenceId INT NOT NULL UNIQUE PRIMARY KEY AUTO_INCREMENT,
    customerId INT NOT NULL,
    favoriteTable VARCHAR(45),
    dietaryRestrictions VARCHAR(200),
    FOREIGN KEY (customerId) REFERENCES customers(customerId)
);

-- Inserting sample data into Customers table
INSERT INTO customers(customerName, contactInfo) VALUES
('John Doe', 'johndoe@example.com'),
('Jane Smith', 'janesmith@example.com'),
('Alice Johnson', 'alicej@example.com'),
('Bob Brown', 'bobbrown@example.com'),
('Charlie Davis', 'charlied@example.com');

-- Inserting sample data into Reservations table
INSERT INTO reservations(customerId, reservationTime, numberOfGuests, specialRequests) VALUES
(1, '2024-05-20 19:00:00', 2, 'Window seat preferred'),
(2, '2024-05-21 20:00:00', 4, 'Allergic to peanuts'),
(3, '2024-05-22 18:30:00', 3, 'Celebrating anniversary'),
(4, '2024-05-23 19:45:00', 5, 'Need high chair for a toddler'),
(5, '2024-05-24 20:30:00', 2, 'Vegetarian meal options');

-- Inserting sample data into DiningPreferences table
INSERT INTO diningPreferences(customerId, favoriteTable, dietaryRestrictions) VALUES
(1, 'Table 5', 'None'),
(2, 'Table 9', 'Gluten-free'),
(3, 'Table 20', 'Vegetarian'),
(4, 'Table 15', 'No dairy'),
(5, 'Table 1', 'Vegan');

SHOW TABLES;

-- Select statements
SELECT * FROM customers;
SELECT * FROM reservations;
SELECT * FROM diningPreferences;

-- MySQL Procedures and Modifications

-- 1. Stored Procedures and Relationships

-- Procedure to find all reservations for a customer using their ID
DELIMITER //
CREATE PROCEDURE findReservations(IN in_customerId INT)
BEGIN
    SELECT * FROM reservations WHERE customerId = in_customerId;
END //
DELIMITER ;

-- Procedure to update the specialRequests field in the reservations table
DELIMITER //
CREATE PROCEDURE addSpecialRequest(IN in_reservationId INT, IN in_requests VARCHAR(200))
BEGIN
    UPDATE reservations SET specialRequests = in_requests WHERE reservationId = in_reservationId;
END //
DELIMITER ;

-- Procedure to create a new reservation with customer details
DELIMITER //
CREATE PROCEDURE addReservation(
    IN in_customerName VARCHAR(45), 
    IN in_contactInfo VARCHAR(200), 
    IN in_reservationTime DATETIME, 
    IN in_numberOfGuests INT, 
    IN in_specialRequests VARCHAR(200)
)
BEGIN
    DECLARE customerId INT;
    
    -- Check if customer already exists
    SELECT customerId INTO customerId FROM customers 
    WHERE customerName = in_customerName AND contactInfo = in_contactInfo;
    
    -- If customer does not exist, create a new one
    IF customerId IS NULL THEN
        INSERT INTO customers (customerName, contactInfo) VALUES (in_customerName, in_contactInfo);
        SET customerId = LAST_INSERT_ID();
    END IF;
    
    -- Add reservation
    INSERT INTO reservations (customerId, reservationTime, numberOfGuests, specialRequests) VALUES
    (customerId, in_reservationTime, in_numberOfGuests, in_specialRequests);
END //
DELIMITER ;
