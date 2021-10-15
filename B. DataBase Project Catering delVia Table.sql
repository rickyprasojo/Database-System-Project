-- 2301908476 Ricky Prasojo
-- 2301890850 Yobel Sahala Sitorus
-- 2301858042 Yohanes Raditya Wirawan Aruan
-- 2301955900 Wahyu Raihan Hidayat

CREATE DATABASE CateringdelVia

--  2. CREATE TABLE

CREATE TABLE Position (
PositionID VARCHAR(5) PRIMARY KEY CHECK (PositionID LIKE 'SP[0-9][0-9][0-9]'),
PositionName VARCHAR(255) 
)

CREATE TABLE Staff (
StaffID VARCHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
PositionID VARCHAR(5) NOT NULL,
StaffName VARCHAR(255) NOT NULL,
Gender VARCHAR(255) CHECK (Gender LIKE 'Male' OR Gender LIKE 'Female') NOT NULL,
StaffEmail VARCHAR(255) CHECK (StaffEmail NOT LIKE '@%' AND StaffEmail LIKE '%@gmail.com' OR StaffEmail LIKE'%@yahoo.com' OR StaffEmail LIKE '%@yahoo.co.id') NOT NULL,
StaffPhoneNumber VARCHAR(12) CHECK (StaffPhoneNumber LIKE '08%') NOT NULL,
StaffAddress VARCHAR(255) NOT NULL,
Salary INTEGER CHECK (Salary BETWEEN 500000 AND 5000000) NOT NULL,
FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
)

CREATE TABLE Vendor (
VendorID VARCHAR(5) PRIMARY KEY CHECK (VendorID LIKE 'VE[0-9][0-9][0-9]') NOT NULL,
VendorName VARCHAR(255) CHECK (VendorName LIKE 'PT.%') NOT NULL,
VendorPhoneNumber VARCHAR(12) CHECK (VendorPhoneNumber LIKE '08%') NOT NULL,
VendorAddress VARCHAR(255) NOT NULL
)

CREATE TABLE Ingredient (
IngredientID VARCHAR(5) PRIMARY KEY CHECK (IngredientID LIKE 'ID[0-9][0-9][0-9]') NOT NULL,
IngredientName VARCHAR(255) NOT NULL,
Stock INTEGER NOT NULL,
Price INTEGER NOT NULL
)

CREATE TABLE Purchase ( 
PurchaseID VARCHAR(5) PRIMARY KEY CHECK (PurchaseID LIKE 'PU[0-9][0-9][0-9]') NOT NULL,
StaffID VARCHAR(5) NOT NULL,
VendorID VARCHAR(5) NOT NULL,
PurchaseDate DATE NOT NULL,
FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
)

CREATE TABLE PurchaseDetail (
PurchaseID VARCHAR(5),
IngredientID VARCHAR(5),
IngredientsPurchased VARCHAR(255) NOT NULL,
Qty INTEGER NOT NULL,
FOREIGN KEY (PurchaseID) REFERENCES Purchase(PurchaseID),
FOREIGN KEY (IngredientID)REFERENCES Ingredient(IngredientID)
)

CREATE TABLE Customer (
CustomerID VARCHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]') NOT NULL,
CustomerName VARCHAR(255) NOT NULL,
CustomerPhoneNumber VARCHAR(12) CHECK (CustomerPhoneNumber LIKE '08%') NOT NULL,
CustomerAddress VARCHAR(255) NOT NULL,
Gender VARCHAR(255) CHECK (Gender LIKE 'Male' OR Gender LIKE 'Female') NOT NULL,
CustomerEmail VARCHAR(255) CHECK (CustomerEmail NOT LIKE '@%' AND CustomerEmail LIKE '%@gmail.com' OR CustomerEmail LIKE'%@yahoo.com' OR CustomerEmail LIKE '%@yahoo.co.id') NOT NULL
)

CREATE TABLE Menu (
MenuID VARCHAR(5) PRIMARY KEY CHECK (MenuID LIKE 'ME[0-9][0-9][0-9]') NOT NULL,
MenuName VARCHAR(255) CHECK (LEN(MenuName)>5) NOT NULL,
MenuDescription VARCHAR(255) NOT NULL,
MenuPrice INTEGER NOT NULL
)

CREATE TABLE [Transaction] (
ServiceID VARCHAR(5) PRIMARY KEY CHECK (ServiceID LIKE 'TR[0-9][0-9][0-9]') NOT NULL,
StaffID VARCHAR(5) NOT NULL,
CustomerID VARCHAR(5) NOT NULL,
TransactionDate DATE NOT NULL,
ReservationType VARCHAR(255) NOT NULL,
ReservationAddress VARCHAR(255) NOT NULL,
FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
)

CREATE TABLE ServiceTransaction (
ServiceID VARCHAR(5) NOT NULL,
MenuID VARCHAR(5) NOT NULL,
PaxOfEachMenu INTEGER NOT NULL,
FOREIGN KEY (ServiceID) REFERENCES [Transaction](ServiceID),
FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
)

