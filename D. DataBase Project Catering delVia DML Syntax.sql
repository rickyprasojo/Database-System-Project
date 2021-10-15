-- D. DML Syntax

-- Staf melihat daftar jabatan
SELECT*FROM Position

-- Staff mendaftarkan kode staff, kode jabatan, data diri dan gaji
INSERT INTO Staff
VALUES('ST020', 'SP010', 'Rafael', 'Male', 'rfl@gmail.com', '08123456745', 'Jalan dua', '3000000')

-- Staff mendaftarkan nama Vendor
INSERT INTO Vendor
VALUES('VE016', 'PT. TV', '087654527109', 'Balikpapan')

-- Staff mendaftarkan nama menu, detail ,dan harga
INSERT INTO Menu
VALUES('ME001', 'Komplit Ayam Goreng', 'Ayam Goreng, Sayur, Nasi, Sambal, Tempe', '40000')

-- Staff membeli bahan dari vendor dan memasukkannya ke table
INSERT INTO Purchase
VALUES('PU026', 'ST020', 'VE001', '2020-06-27')

-- Staff menuliskan detail pembelian
INSERT INTO PurchaseDetail
VALUES('PU026', 'ID001', 'Bawang Merah', '100')

-- Staff mencatat detail customer, jenis dan pesanan customer
INSERT INTO Customer
VALUES('CU020', 'Ariel Tatum', '087523134640', 'Jakarta', 'Female', 'ibunda@yahoo.co.id')
INSERT INTO [Transaction]
VALUES('TR009', 'ST018', 'CU020', '2020-07-21', 'Individual', 'Jakarta')
INSERT INTO ServiceTransaction
VALUES('TR009', 'ME010', '40')

-- Staff mencetak struk
SELECT
ServiceID,
StaffID,
CustomerID,
TransactionDate,
ReservationType,
ReservationAddress
FROM
[Transaction],
Staff,
Customer,
Menu

-- Catering siap dimasak dan diantar


