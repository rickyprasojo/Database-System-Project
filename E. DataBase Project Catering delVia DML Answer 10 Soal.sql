-- E. Answer

-- 1.
SELECT StaffName, PositionName, COUNT([Transaction].StaffID) AS [Total Activity]
FROM Staff 
JOIN Position 
ON Position.PositionID= Staff.PositionID
JOIN [Transaction] 
ON [Transaction].StaffID= Staff.StaffID
WHERE (Salary >=1000000 AND Salary <=4000000 )
AND((SELECT COUNT(StaffID)
FROM [Transaction]) > 2)
GROUP BY StaffName, PositionName
UNION
SELECT StaffName, PositionName, COUNT(Purchase.StaffID) AS [Total Activity]
FROM Staff 
JOIN Position 
ON Position.PositionID= Staff.PositionID
JOIN Purchase 
ON Purchase.StaffID= Staff.StaffID
WHERE (Salary >=1000000 AND Salary <=4000000 )
AND((SELECT COUNT(StaffID)
FROM Purchase) > 2)
GROUP BY StaffName, PositionName

-- 2.
SELECT Customer.CustomerID, Customer.CustomerName, COUNT(ServiceTransaction.MenuID) as [Pax Bought]
FROM ServiceTransaction
JOIN [Transaction] 
ON ServiceTransaction.ServiceID = [Transaction].ServiceID
JOIN Customer 
ON Customer.CustomerID= [Transaction] .CustomerID
WHERE (Customer.Gender like 'Male%') 
AND ([Transaction].TransactionDATE >= '01/01/2020' AND [Transaction].TransactionDATE <= '06/30/2020')
GROUP BY Customer.CustomerID, Customer.CustomerName 

-- 3.
select
IngredientName,
'Ingridient Bought' = pd2.tq,
'Purchase Count' = pd2.tp,
'Total Expenses' = pd2.tq*i.Price
from PurchaseDetail pd
join Ingredient i on i.IngredientID=pd.IngredientID
join Purchase p on p.PurchaseID=pd.PurchaseID
join (
	select
	IngredientID,
	'tq' = sum(Qty),
	'tp' = count(PurchaseID)
	from PurchaseDetail
	group by IngredientID
) pd2 on pd2.IngredientID=pd.IngredientID
where month(PurchaseDate)%2 = 0 and day(PurchaseDate)%7 >= 1 and day(PurchaseDate)%7 <= 4
group by IngredientName, pd2.tq, pd2.tp, i.Price

-- 4.
select
'Staff First Name' = left(s.StaffName, charindex(' ', s.StaffName)-1),
'Transaction Count' = (
	select
	count(t2.ServiceID)
	from [Transaction] t2
	where cast(right(t2.CustomerID, 3) as int)%2 = 0 and t2.StaffID=t.StaffID
	),
'Pax Sold' = (
	select
	sum(td2.Qty)
	from [Transaction] t2
	join PurchaseDetail td2 on td2.ServiceID=t2.ServiceID
	where cast(right(t2.CustomerID, 3) as int)%2 = 0 and t2.StaffID=t.StaffID
	)
from [Transaction] t
join Staff s on t.StaffID=s.StaffID
join PurchaseDetail td on td.ServiceID=t.ServiceID
where cast(right(s.StaffID, 3) as int)%2 = 1 and cast(right(CustomerID, 3) as int)%2 = 0
group by s.StaffName, t.StaffID


-- 5.
select
'Vendor Name' = replace(VendorName, 'PT. ', ''),
IngredientName,
'IngridientPrice' = i.Price
from Purchase p
join PurchaseDetail pd on p.PurchaseID=pd.PurchaseID
join Vendor v on p.VendorID=v.VendorID
join Ingredient i on pd.IngredientID=i.IngredientID
join (
	select
	p.PurchaseID,
	'ave' = (
		select
		avg(i2.Price)
		from PurchaseDetail pd2
		join Ingredient i2 on i2.IngredientID=pd2.IngredientID
		where pd2.PurchaseID=p.PurchaseID
	)
	from Purchase p
) temp on temp.PurchaseID=p.PurchaseID
where i.Price>=temp.ave and Stock<250

-- 6.
select
CustomerName,
'TransactionDate' = convert(varchar, TransactionDATE, 107),
MenuName,
'Brief Description' = left(replace(MenuDescription, '  ', ' '), charindex(' ', replace(MenuDescription, '  ', ' '), charindex(' ', replace(MenuDescription, '  ', ' '))+1)),
'Pax' = Quantity,
'Total Price' = cast(MenuPrice as int)*Quantity
from Customer c
join [Transaction] t on t.CustomerID=c.CustomerID
join ServiceTransaction td on td.TransactionID=t.TransactionID
join Menu m on m.MenuID=td.MenuID
join (
	select
	t.TransactionID,
	'ave' = (
		select
		avg(cast(m2.MenuPrice as int))
		from ServiceTransaction td2
		join Menu m2 on td2.MenuID=m2.MenuID
		where td2.TransactionID=t.TransactionID
	)
	from [Transaction] t
) temp on temp.TransactionID=t.TransactionID
where MenuPrice>temp.ave and Qty>100

-- 7.
select
'Staff Name' = upper(StaffName),
'Purchase Date' = convert(varchar, PurchaseDate, 107),
'Quantity Bought' = cast(sum(temp.Qty) as varchar) + ' pcs'
from Staff s
join Purchase p on p.StaffID=s.StaffID
join (
	select
	PurchaseID,
	pd.IngredientID,
	Qty,
	Price
	from PurchaseDetail pd
	join Ingredient i on i.IngredientID=pd.IngredientID
	where i.Price < (select max(i2.Price) from Ingredient i2)
) temp on temp.PurchaseID=p.PurchaseID
where month(PurchaseDate)%2=0
group by StaffName, PurchaseDate, p.PurchaseID

-- 8.
select
c.CustomerName,
'Email' = left(c.CustomerEmail, charindex('@', c.CustomerEmail)-1),
'Menu Name' = lower(m.MenuName),
'Pax Bought' = td.Quantity
from Customer c
join [Transaction] t on t.CustomerID=c.CustomerID
join ServiceTransaction st on st.ServiceID=t.ServiceID
join Menu m on m.MenuID=td.MenuID
join (
	select
	t.TransactionID,
	'ap' = avg(Qty)
	from [Transaction] t
	join ServiceTransaction st on st.ServiceID=t.ServiceID
	group by t.ServiceID
) temp on temp.ServiceID=t.ServiceID
where c.Gender like 'M%' and st.Qty>=temp.ap

-- 9.
go
create view LoyalCustomerView as
select
c.CustomerName,
'Total Transaction' = temp.tt,
'Total Pax Purchased' = temp2.tp,
'Total Price' = temp3.tpr
from Customer c
join (
	select
	c.CustomerID,
	'tt' = count(t.ServiceID)
	from Customer c
	join [Transaction] t on t.CustomerID=c.CustomerID
	group by c.CustomerID
) temp on temp.CustomerID=c.CustomerID
join (
	select
	t.CustomerID,
	'tp' = sum(td.Qty)
	from [Transaction] t
	join ServiceTransaction td on t.TransactionID=td.TransactionID
	group by t.CustomerID
) temp2 on temp2.CustomerID=c.CustomerID
join (
	select
	t.CustomerID,
	'tpr' = sum(m.MenuPrice*td.Quantity)
	from [Transaction] t
	join Transaction_Detail td on td.TransactionID=t.TransactionID
	join Menu m on m.MenuID=td.MenuID
	group by t.CustomerID
) temp3 on temp3.CustomerID=c.CustomerID
where c.Gender like 'F%' and temp.tt>2

go

-- 10.
go
create view VendorRecapView as
select
v.VendorName,
'Purchase Made' = temp.tp,
'Ingredients Purchased' = temp2.tq
from Vendor v
join (
	select
	VendorID,
	'tp' = count(PurchaseID)
	from Purchase p
	group by VendorID
) temp on temp.VendorID=v.VendorID
join (
	select
	VendorID,
	'tq' = sum(Qty)
	from PurchaseDetail pd
	join Purchase p on p.PurchaseID=pd.PurchaseID
	join Ingredient i on i.IngredientID=pd.IngredientID
	where i.Stock>150
	group by VendorID
) temp2 on temp2.VendorID=v.VendorID
where temp.tp>1

go