USE `<your_student_ID_number>_cat1`;

START TRANSACTION;

-- List of tables to create (in the specified order):
-- 1. branch
-- 2. employee
-- 3. customer
-- 4. orderStatus
-- 5. customerOrder
-- 6. product
-- 7. paymentMethod
-- 8. payment
-- 9. orderDetail

SET foreign_key_checks = 0;
DROP TABLE IF EXISTS branch; 
DROP TABLE IF EXISTS employee; 
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS orderStatus;
DROP TABLE IF EXISTS customerOrder;
DROP TABLE IF EXISTS productcategory;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS paymentMethod;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS orderDetail;
SET foreign_key_checks = 1;

-- Create branch Table
CREATE TABLE branch (
    branchCode INT AUTO_INCREMENT PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    addressLine1 VARCHAR(100) NOT NULL,
    addressLine2 VARCHAR(100),
    postalCode VARCHAR(20) NOT NULL,
    county VARCHAR(50) NOT NULL,
    subCounty VARCHAR(50) NOT NULL
);

-- Create employee Table
CREATE TABLE employee (
    employeeNumber INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    branchCode INT NOT NULL,
    jobTitle VARCHAR(50) NOT NULL,
    reportsTo INT,
    CONSTRAINT FK_1_branch_to_M_employee FOREIGN KEY (branchCode) REFERENCES branch (branchCode)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_employee_to_M_employee FOREIGN KEY (reportsTo) REFERENCES employee (employeeNumber)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create customer Table
CREATE TABLE customer (
    customerNumber INT AUTO_INCREMENT PRIMARY KEY,
    customerName VARCHAR(100) NOT NULL,
    contactFirstName VARCHAR(50) NOT NULL,
    contactLastName VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    addressLine1 VARCHAR(100) NOT NULL,
    addressLine2 VARCHAR(100),
    postalCode VARCHAR(20) NOT NULL,
    county VARCHAR(50) NOT NULL,
    subCounty VARCHAR(50) NOT NULL,
    salesRepEmployeeNumber INT,
    CONSTRAINT FK_1_employee_to_M_customer FOREIGN KEY (salesRepEmployeeNumber) REFERENCES employee(employeeNumber)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create Order Status Lookup Table
CREATE TABLE orderStatus (
    orderStatusID INT AUTO_INCREMENT PRIMARY KEY,
    status VARCHAR(50) NOT NULL UNIQUE
);

-- Create customerOrder Table
CREATE TABLE customerOrder (
    orderNumber INT AUTO_INCREMENT PRIMARY KEY,
    orderDate DATETIME NOT NULL,
    requiredDate DATETIME NOT NULL,
    dispatchDate DATETIME,
    orderStatusID INT NOT NULL,
    customerNumber INT NOT NULL,
    CONSTRAINT FK_1_customer_to_M_customerOrder FOREIGN KEY (customerNumber) REFERENCES customer(customerNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_orderStatus_to_M_customerOrder FOREIGN KEY (orderStatusID) REFERENCES orderStatus(orderStatusID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Create productCategory Table
CREATE TABLE productCategory (
    productCategoryID INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(50) NOT NULL UNIQUE,
    categoryDescription TEXT
);

-- Create product Table
CREATE TABLE product (
    productCode VARCHAR(20) PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    productDescription TEXT NOT NULL,
    quantityInStock INT NOT NULL CHECK (quantityInStock >= 0),
    costOfProduction DECIMAL(10, 2) NOT NULL,
    sellingPrice DECIMAL(10, 2) NOT NULL,
    productCategoryID INT,
    CONSTRAINT FK_1_productCategory_to_M_product FOREIGN KEY (productCategoryID) REFERENCES productCategory(productCategoryID)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- Create Payment Methods Lookup Table
CREATE TABLE paymentMethod (
    paymentMethodID INT AUTO_INCREMENT PRIMARY KEY,
    paymentMethod VARCHAR(50) NOT NULL UNIQUE
);

-- Create payment Table
CREATE TABLE payment (
    paymentNumber INT AUTO_INCREMENT PRIMARY KEY,
    orderNumber INT NOT NULL,
    paymentDate DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paymentMethodID INT NOT NULL,
    CONSTRAINT FK_1_customerOrder_to_M_payment FOREIGN KEY (orderNumber) REFERENCES customerOrder(orderNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_paymentMethod_to_M_payment FOREIGN KEY (paymentMethodID) REFERENCES paymentMethod(paymentMethodID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = MyISAM;

-- Create Order Details Table
CREATE TABLE orderDetail (
    orderDetailNumber INT AUTO_INCREMENT PRIMARY KEY,
    orderNumber INT NOT NULL,
    productCode VARCHAR(20) NOT NULL,
    quantityOrdered INT NOT NULL,
    priceEach DECIMAL(10, 2) NOT NULL, 
    CONSTRAINT FK_1_customerOrder_to_M_orderDetails FOREIGN KEY (orderNumber) REFERENCES customerOrder(orderNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_1_product_to_M_orderDetails FOREIGN KEY (productCode) REFERENCES product(productCode)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

COMMIT;