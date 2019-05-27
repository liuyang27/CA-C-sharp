USE ShoppingCartDB
GO

CREATE TABLE Product
(
	ID int primary key not null,
	ProductName nvarchar(50) not null,
	ProductDescription nvarchar(500) not null,
	UnitPrice decimal(10,2) not null,
	ImageSource nvarchar(200)
)

insert into Product(ID,ProductName,ProductDescription,UnitPrice) values(1,'.NET Charts','Brings powerful charting capabilities to your .NET applications.',99)
insert into Product(ID,ProductName,ProductDescription,UnitPrice) values(2,'.NET PayPal','Integrate your .NET apps with PayPal the easy way!',69)
insert into Product(ID,ProductName,ProductDescription,UnitPrice) values(3,'.NET ML','Supercharged .NET machine learning libraries.',299)
insert into Product(ID,ProductName,ProductDescription,UnitPrice) values(4,'.NET Analytics','Performs data mining and analytics easily in .NET.',299)
insert into Product(ID,ProductName,ProductDescription,UnitPrice) values(5,'.NET Logger','Logs and aggregates events easily in your .NET apps.',49)
insert into Product(ID,ProductName,ProductDescription,UnitPrice) values(6,'.NET Numerics','Powerful numerical methods for your .NET simulations.',199)

CREATE TABLE Customer
(
	ID int primary key not null,
	CustomerName nvarchar(20) not null,
	UserName nvarchar(20)not null,
	Password nvarchar(50) not null,
	SessionID nvarchar(50)
)

--password is 123

insert into Customer(ID,CustomerName,UserName,Password) values(1,'Hans Lang','hanslang','202cb962ac59075b964b07152d234b70')
insert into Customer(ID,CustomerName,UserName,Password) values(2,'Glendon Tan','glendon','202cb962ac59075b964b07152d234b70')


CREATE TABLE Purchased
(
	ID int identity primary key not null,
	CustomerID int not null,
	ProductID int not null,
	UnitPrice Decimal(10,2) not null,
	PurchaseDate Datetime not null,
	ActivationCode nvarchar(50) not null
	constraint FK_Purchased_CustomerID foreign key (CustomerID) references Customer(ID),
	constraint FK_Purchased_ProductID foreign key (ProductID) references Product(ID)
)

CREATE TABLE Cart
(
	ID int identity primary key not null,
	CustomerID int not null,
	ProductID int not null,
	UnitPrice Decimal(10,2) not null,
	Quantity int not null,
	
	constraint FK_Cart_CustomerID foreign key (CustomerID) references Customer(ID),
	constraint FK_Cart_ProductID foreign key (ProductID) references Product(ID)
)

update Product set ImageSource='/Images/charts.png'where ID=1
update Product set ImageSource='/Images/paypal.png'where ID=2
update Product set ImageSource='/Images/machinelearning.png'where ID=3
update Product set ImageSource='/Images/analytics.png'where ID=4
update Product set ImageSource='/Images/logger.png'where ID=5
update Product set ImageSource='/Images/numerics.png'where ID=6


CREATE PROCEDURE spCheckout
@CustomerID int
as
BEGIN
	Declare @count int
	Declare @row int
	Declare @timestamp datetime
	select @count=count(*) from cart where CustomerID =@CustomerID
	if @count>0
	begin
		create table #tempTable
		(
			CustomerID int,
			ProductID int,
			UnitPrice decimal(10,2),
			PurchaseDate datetime,
			ActivationCode nvarchar(50)
		)
		set @row=0
		set @timestamp=GETDATE()
		while @row<@count
		begin
			Declare @ProductID int
			Declare @UnitPrice decimal(10,2)
			Declare @quantity int
			Declare @i int
			set @i=0
			select top 1 @CustomerID=CustomerID,@ProductID=ProductID,@UnitPrice=UnitPrice, @quantity=Quantity 
					from cart where CustomerID =@CustomerID
			IF (@quantity<1)
			begin
				delete from Cart where CustomerID=@CustomerID and ProductID=@ProductID
			end
			ELSE
			begin
				while @i<@quantity
				begin
					insert into #tempTable values(@CustomerID,@ProductID,@UnitPrice,@timestamp,NEWID())
					delete from Cart where CustomerID=@CustomerID and ProductID=@ProductID
					set @i=@i+1
				end
			end

			set @row=@row+1
		end
		insert into Purchased select * from #tempTable
		drop table #tempTable
	end
END


Create PROCEDURE spAddProduct
@CustomerID int,
@ProductID int
as
BEGIN
	Declare @count int
	select @count=Quantity from cart where CustomerID =@CustomerID and ProductID=@ProductID
	set @count=@count+1
	update Cart set Quantity=@count where CustomerID =@CustomerID and ProductID=@ProductID		
END


--****************************** BELOW FOR TESTING ONLY ************************************


insert into Cart values(1,2,69,2)
insert into Cart values(1,1,99,1)
insert into Cart values(1,5,49,3)
insert into Cart values(2,4,299,1)
insert into Cart values(2,5,49,3)
select * from Cart
select * from Purchased

truncate table Purchased
select * from Customer

select * from Product

select * from Product where ProductName like '%%' or ProductDescription like '%%'


update Cart set UnitPrice=99 where ProductID=1


update Customer set SessionID='555555555552222222222' where UserName='hafang'


select sum(quantity) from Cart where CustomerID=1

select * from Cart where CustomerID=1
select count(*) from cart where CustomerID =1



select ProductID, count(ProductID) as Quantity,PurchaseDate from Purchased where CustomerID=1 group by ProductID,PurchaseDate order by PurchaseDate desc


insert into Purchased values(1,5,49.00,convert(date,'2019-04-07 04:12:45:333'),222222222278)

select ActivationCode from Purchased where CustomerID=1 and ProductID=2 and PurchaseDate='2019-04-04'

select ProductName,ProductDescription,ImageSource from Product where id=1

select CONVERT(nvarchar(30),Getdate(),120) as teimstamp

select * from test
insert into test values(GETDATE(),GETDATE())

select * from Cart where CustomerID=1


select * from Purchased where CustomerID=1

exec spCheckout 1

insert into Purchased values(1,1,99,GETDATE(),'1111111')
truncate table Purchased

select * from customer

delete from Cart where CustomerID=1 and ProductID=1