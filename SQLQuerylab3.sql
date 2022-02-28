use Lab02;

select*
from Client;

create procedure getQuantity @pno varchar(6),@qty int out
as
begin
select @qty=qty_available
from product 
where productNo=@pno 
end

declare @qa int
exec getQuantity 'p0001',@qa output
print @qa

go 

create procedure updatesprice @pno varchar(6),@sprice money
as
begin
   declare @item_cost money
   select @item_cost=item_cost from product where productNo=@pno
   if @sprice>@item_cost
    begin
     update product set selling_price=@sprice
	 where productNo=@pno
    end 
   else
    begin
	 print 'Selling price should be greater than the item cost. Record update terminated'
    end
end

exec updatesprice 'p0001',4000
exec updatesprice 'p0001',1000

select *
from Sales_Order

go

create procedure q5 
@Sales_Order_No int,
@Sales_Order_Date datetime,
@Order_Taken_By varchar(20),
@ClientNo varchar(6),
@Delivery_Address varchar(255)
as
begin
insert into Sales_Order values(@Sales_Order_No,
@Sales_Order_Date,
@Order_Taken_By,
@ClientNo,
@Delivery_Address)
end

exec q5 15,'12-Aug-2010','Sunil','C009','Colombo'


go

create procedure q6 
@Sales_Order_No int,
@Sales_Order_Date datetime,
@Order_Taken_By varchar(20),
@ClientNo varchar(6),
@Delivery_Address varchar(255),
@Product_No varchar(6),
@Quantity int
as
begin
insert into Sales_Order values(@Sales_Order_No,
@Sales_Order_Date,
@Order_Taken_By,
@ClientNo,
@Delivery_Address)

insert into Sales_Order_Details values(@Sales_Order_No,
@Product_No,
@Quantity)
end

exec q6 16,'12-Aug-2010','Sunil','C009','Colombo','p0006',50



go

create procedure q7
@Sales_Order_No int,
@Sales_Order_Date datetime,
@Order_Taken_By varchar(20),
@ClientNo varchar(6),
@Delivery_Address varchar(255),
@Product_No varchar(6),
@Quantity int,
@name varchar(20),
@city varchar(20),
@date_joined datetime,
@balance_due money
as
begin
insert into Sales_Order values(@Sales_Order_No,
@Sales_Order_Date,
@Order_Taken_By,
@ClientNo,
@Delivery_Address)

insert into Sales_Order_Details values(@Sales_Order_No,
@Product_No,
@Quantity)



   if not Exists (select*from client where clientNo=@ClientNo)
    begin
     insert into client values (
	 @ClientNo,
	 @name ,
     @city ,
     @date_joined ,
     @balance_due);
    end 
end



exec q7 17,'12-Aug-2010','Sunil','C009','Colombo','p0006',50,'Sagara','Colombo','2010-12-20', $25000
