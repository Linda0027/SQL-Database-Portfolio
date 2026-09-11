-- ====================================================================
-- PROJECT: IIE ROSEBANK COLLEGE - DBAS6211 PRACTICAL ASSESSMENT
-- PURPOSE: Fitness Centre Relational Schema Architecture & DML Validation
-- AUTHOR:  Linda Mxolisi Nkosi
-- PLATFORM: MySQL / phpMyAdmin Workspace Environment
-- ====================================================================

-- Q.3.1 Create Parent Schema Architecture: Customer Table
CREATE TABLE Customer (
    CustomerID INT NOT NULL,
    CustomerFullName VARCHAR(255) NOT NULL,
    CustomerEmail VARCHAR(255) NOT NULL,
    PRIMARY KEY (CustomerID)
);

-- Q.3.2 Create Child Schema Architecture: Orders Table with Foreign Key
CREATE TABLE Orders (
    OrderID INT NOT NULL,
    OrderNumber VARCHAR(50) NOT NULL,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Q.3.3 Data Ingestion Phase (Preserving Relational Continuity)
-- Step A: Ingest Parent Profile Entry First
INSERT INTO Customer (CustomerID, CustomerFullName, CustomerEmail) 
VALUES (1, 'Debbie Duncan', 'dduncan@yahoo.com');

-- Step B: Ingest Child Transaction Linked to the Active Customer ID
INSERT INTO Orders (OrderID, OrderNumber, CustomerID, OrderDate) 
VALUES (1, '020149', 1, '2024-02-14');

-- Q.3.4 Operational Data Mutation (UPDATE Row Execution)
UPDATE Orders 
SET OrderDate = '2024-02-15' 
WHERE OrderID = 1;

-- Q.3.5 Operational Data Eviction (DELETE Row Execution)
DELETE FROM Orders 
WHERE OrderID = 1;
