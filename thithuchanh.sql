--kiểm tra xem đã có CSDL AZBank chưa có rồi thì xóa đi.
IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'AZBank')
	DROP DATABASE AZBank
GO
-- 1. Create database named AZBank.
CREATE DATABASE AZBank
GO
USE AZBank
GO
-- 2. In the AZBank database, create tables with constraints as design above.
CREATE TABLE Customer (
	CustomerID INT PRIMARY KEY,
	Name NVARCHAR(50),
	City NVARCHAR(50),
	Country NVARCHAR(50),
	Phone NVARCHAR(15),
	Email NVARCHAR(50)
)
GO
CREATE TABLE CustomerAccount (
	AccountNumber CHAR(9) PRIMARY KEY,
	CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
	Balance MONEY NOT NULL,
	MinAccount MONEY
)
GO
CREATE TABLE CustomerTransaction (
	TransactionID INT PRIMARY KEY,
	AccountNumber CHAR(9) FOREIGN KEY REFERENCES CustomerAccount(AccountNumber),
	TransactionDate SMALLDATETIME,
	Amount MONEY,
	DepositorWithdraw BIT
)
GO
-- 3. Insert into each table at least 3 records.
INSERT INTO Customer
	VALUES
		(1, N'Lương Viết Hoàng', N'Hạ Long', N'Quảng Ninh', N'0979908276', N'hoangckhg170@gmail.com'),
		(2, N'Ngô Bá Khánh', N'Nhật Tân', N'Hà Nội', N'0123456789', N'ngobakhanh@gmail.com'),
		(3, N'Tạ Duy Linh', N'Thái Nguyên', N'Phú Bình', N'0987654321', N'duylinhta@gmail.com')
GO
INSERT INTO CustomerAccount
	VALUES
		('A12345', 1, 1000000000, 1000000),
		('A12346', 2, 10000000000, 10000000),
		('A12347', 3, 100000000000, 10000000)
GO
INSERT INTO CustomerTransaction
	VALUES
		(1, 'A12345', '20220115 18:00:30', 100000, 1),
		(2, 'A12346', '20211228 09:19:01', 10000000, 0),
		(3, 'A12347', '20220109 11:11:11', 5000000, 1)
GO
-- 4. Write a query to get all customers from Customer table who live in ‘Hanoi’.
SELECT * FROM Customer
WHERE City = N'Hà Nội'
GO
-- 5. Write a query to get account information of the customers (Name, Phone, Email, AccountNumber, Balance).
SELECT Name, Phone, Email, CustomerAccount.AccountNumber, CustomerAccount.Balance FROM Customer
JOIN CustomerAccount
ON CustomerAccount.CustomerID = Customer.CustomerID
GO
-- 6. A-Z bank has a business rule that each transaction (withdrawal or deposit) 
ALTER TABLE CustomerTransaction
	ADD CONSTRAINT ck_Amount CHECK (Amount > 0 AND Amount <= 1000000 )
GO
-- 7. Create a view named vCustomerTransactions 
CREATE VIEW vCustomerTransactions 
AS
SELECT Name, CustomerAccount.AccountNumber, CustomerTransaction.TransactionDate, CustomerTransaction.Amount,
		CustomerTransaction.DepositorWithdraw FROM Customer
JOIN CustomerAccount
ON CustomerAccount.CustomerID = Customer.CustomerID
JOIN CustomerTransaction
ON CustomerTransaction.AccountNumber = CustomerAccount.AccountNumber