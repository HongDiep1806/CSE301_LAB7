use SaleManagement;
-- . SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman"
-- table
select distinct city from clients
union all
select distinct city from salesman;
-- 2. SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table.
select city from clients
union all
select city from salesman;
-- 3. SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the
-- "salesman" table.
select distinct city from clients
where city = 'Ho Chi Minh'
union all
select distinct city from salesman
where city = 'Ho Chi Minh';
-- 4. SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the
-- "salesman" table.
select city from clients
where city = 'Ho Chi Minh'
union all
select city from salesman
where city = 'Ho Chi Minh';
-- 5. SQL statement lists all Clients and salesman.
select Client_Name as listAll from clients
union all
select Salesman_Name as listAll from salesman;
-- 6. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with
-- information: ID, Name, City and Type.
select Client_Number as ID, Client_Name as Name, City, 'Client' as Type
 from clients
where city = 'Hanoi'
union all
select Salesman_Number as ID, Salesman_Name as Name, City,'Saleman' as Type from salesman
where city = 'Hanoi';
-- 7. Write a SQL query to find those salesman and clients who have placed more than one order. Return
-- ID, name and order by ID.
with A as (select ss.Salesman_Number as snumber ,ss.Salesman_Name as sname, count(so.Order_Number) as numOfOrder from salesman ss join salesorder so
on ss.Salesman_Number = so.Salesman_Number
group by ss.Salesman_Number)
select snumber as ID, sname as `Name` from A
where numOfOrder > 1
order by snumber;
-- 8. Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client
-- names who placed orders and the salesman names who processed those orders.
with A as (select Client_Name as `Name`,so.Order_Number, 'Client' as Type from clients c join salesorder so
on c.Client_Number = so.Client_Number
union all
select Salesman_Name as `Name`,so.Order_Number,'Saleman' as Type from salesman ss join salesorder so
on ss.Salesman_Number = so.Salesman_Number)
select * from A
order by order_number;
-- 9. Write a SQL query to create a union of two queries that shows the salesman, cities, and
-- target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High
-- Achieved', while the others will have the words 'Low Achieved'.
select Salesman_Name, City, Target_Achieved,
case
when Target_Achieved > 60 then 'High Achieved' else 'Low Achieved'
end as Achievement
from salesman;
-- 10. Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name,
-- Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are
-- labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'
select Product_Number as ID, Product_Name as Name, Quantity_On_Hand as Quantity,
case
when Quantity_On_Hand > 0 then 'More 5 pieces in Stock'
when Quantity_On_Hand = 0 then 'Less 5 pieces in Stock'
end as Stock_status
from product;
-- 11. Create a procedure stores get_clients _by_city () saves the all Clients in table. Then Call procedure
-- stores
Delimiter $$
create procedure get_clients_by_city ()
Begin
select * from clients;
End$$
Delimiter ;
call get_clients_by_city ();
-- 12. Drop get_clients _by_city () procedure stores.
drop procedure get_clients_by_city;
-- 13. Create a stored procedure to update the delivery status for a given order number. Change value
-- delivery status of order number “O20006” and “O20008” to “On Way”.
Delimiter $$
create procedure updateDeliveryStatus(IN order_id varchar(15))
Begin
update salesorder
set Delivery_Status = 'On Way'
where Order_Number = order_id;
End$$
Delimiter ;
call updateDeliveryStatus('O20006');
-- 14. Create a stored procedure to retrieve the total quantity for each product.
Delimiter $$
create procedure reportQuantity()
Begin
select Product_Number, Product_Name, Quantity_On_Hand+Quantity_Sell as TotalQuantity from product
group by Product_Number,Product_Name;
End$$
Delimiter ;
call reportQuantity();
-- 15. Create a stored procedure to update the remarks for a specific salesman.
Delimiter $$
create procedure updateRemark(IN salesman_ID varchar(15) , IN newRemark varchar(10))
Begin
update salesman
set remarks = newRemark
where Salesman_Number = salesman_ID;
End$$
Delimiter ;
call updateRemark('S004', 'Bad');
select * from salesman;
-- 16. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
Delimiter $$
create procedure find_clients(IN client_ID varchar(10))
Begin
select * from clients
where Client_Number = client_ID;
End$$
Delimiter ;
call find_clients('C102');
-- 17. Create a procedure stores salary_salesman() saves all of clients (salesman_number, salesman_name,
-- salary) having salary >15000. Then execute the first 2 rows and the first 4 rows from the salesman
-- table.
Delimiter $$
create procedure salary_salesman(in limitRow int)
Begin
select Salesman_Number,Salesman_Name,Salary 
from salesman
where Salary > 15000
limit limitRow
;
End$$
Delimiter ;
call salary_salesman(2);
-- 18. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
Delimiter $$
create procedure maxSalary()
Begin
select max(salary) from salesman;
End$$
Delimiter ;
call maxSalary();
-- 19. Create a procedure stores execute finding amount of order_status by values order status of salesorder
-- table.
Delimiter $$
create procedure findAmountStatus(IN statusFind varchar(20))
Begin
select count(Order_Number)as AmountOfOrderStatus from salesorder
where Order_Status = statusFind
group by Order_Status;
End$$
Delimiter ;
drop procedure findAmountStatus;
call findAmountStatus('Successful');
-- 20. Create a stored procedure to calculate and update the discount rate for orders.
-- 21. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000;
-- SALARY = 20000.
Delimiter $$
create procedure countSalesmanWithCondition()
Begin
select count(Salesman_Number) as result, 'LowerThan20000' as `Condition`from salesman
where Salary < 20000
union all
select count(Salesman_Number), 'numGreaterThan20000' from salesman
where Salary > 20000
union all
select count(Salesman_Number), 'numEqualTo20000' from salesman
where Salary = 20000;
End$$
Delimiter ;
call countSalesmanWithCondition();
-- 22. Create a stored procedure to retrieve the total sales for a specific salesman.
Delimiter $$
create procedure totalSales(IN salesman_id varchar(15))
Begin 
select sum(sod.Order_Quality) as total_sales 
from salesorder so join salesorderdetails sod
on so.Order_Number = sod.Order_Number
where so.Salesman_Number = salesman_id
group by so.Salesman_Number;
End$$
Delimiter ;
call totalSales('S004');
-- 23. Create a stored procedure to add a new product:
-- Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price,
-- Cost_Price.
Delimiter $$
create procedure addNewProduct(IN product_number varchar(15), 
								product_name varchar(25),Quantity_On_Hand int,
								Quantity_Sell int,Sell_Price decimal(15,4),Cost_Price decimal(15,4),total_quantity int, exp_date Date, discount_rate int)
Begin
insert into product
value (product_number,product_name,Quantity_On_Hand,Quantity_Sell,Sell_Price,Cost_Price,total_quantity,exp_date, discount_rate);
End$$
Delimiter ;
call addNewProduct('P1009','Cucumber',10,30,1100,850,40,null,10);
-- 24. Create a stored procedure for calculating the total order value and classification:
-- - This stored procedure receives the order code (p_Order_Number) và return the total value
-- (p_TotalValue) and order classification (p_OrderStatus).
-- - Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails ).
-- - LOOP/While: Browse each product and calculate the total order value.
-- - CASE WHEN: Classify orders based on total value:
-- Greater than or equal to 10000: "Large"
-- Greater than or equal to 5000: "Midium"
-- Less than 5000: "Small"
Delimiter $$
create procedure calculatingOrder(
    IN p_Order_Number varchar(50),
    OUT p_TotalValue DECIMAL(15, 2),
    OUT p_OrderStatus VARCHAR(10)
)
Begin
declare done bool default false;
declare cur cursor for select sod.Order_Quality* p.Sell_Price,
case
when sod.Order_Quality* p.Sell_Price > 10000 or sod.Order_Quality* p.Sell_Price = 10000 then 'Large'
when sod.Order_Quality* p.Sell_Price > 5000 or sod.Order_Quality* p.Sell_Price = 5000 then 'Medium'
else 'Small'
end as orderStatus
from salesorderdetails sod join salesorder so 
on sod.Order_Number = so.Order_Number
join product p 
on p.Product_Number = sod.Product_Number
where so.Order_Number = p_Order_Number ;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
OPEN cur;
set p_TotalValue =0;
set p_OrderStatus ='';
processOrder : loop
FETCH cur INTO p_TotalValue, p_OrderStatus;
		if done = true then
        leave processOrder;
        end if;
end loop;
close cur;
End$$
Delimiter ;
CALL calculatingOrder('O20001', @total_value, @order_status);
select @total_value,@order_status;


