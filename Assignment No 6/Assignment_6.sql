-- create database db;
-- use db;
-- create table form(
--     id int auto_increment primary key,
--     name varchar(255),
--     email varchar(255),
--     password varchar(255)
-- );

-- select * from form;


-- create database Assign6_Headquater;
-- use Assign6_Headquater;


-- # Headquarter Database

-- drop table Customer;

-- create table Customer(
--     Customer_id varchar(20) primary key,
--     Customer_name varchar(20),
--     City_id varchar(20),
--     First_order_date date 
-- );

-- # Inserting values into Customer Table
-- insert into Customer values('29','Akshata','1','2023-04-01');
-- insert into Customer values('39','Vishal','2','2023-04-02');


-- # Walk In Customers Table
-- create table Walk_in_customers (
-- 	Customer_id varchar(20) ,
--     Tourism_guide varchar(50) ,
--     Timing date, 
--     foreign key(Customer_id) references Customer(Customer_id)
-- );

-- # Inserting Values into WIC Table
-- insert into Walk_in_customers values('29', 'Vishal','2023-04-01');
-- insert into Walk_in_customers values('39', 'Akshata','2023-04-02');

-- # Mail Order Customers Table
-- create table Mail_order_customers (
-- 	Customer_id varchar(20) ,
--     Post_address varchar(50) ,
--     Timing date, 
--     foreign key(Customer_id) references Customer(Customer_id)
-- );


-- insert into Mail_order_customers values('29', 'Akola', '2023-04-01');
-- insert into Mail_order_customers values('39', 'Mumbai', '2023-04-02');



-- create database assign6_Sales; 
-- use assign6_Sales;

CREATE DATABASE warehouse;
USE warehouse;

# Headquarter Database

-- drop table Customer;

create table Customer(
    Customer_id varchar(20) primary key,
    Customer_name varchar(20),
    City_id varchar(20),
    First_order_date date 
);

# Inserting values into Customer Table
insert into Customer values('29','Akshata','1','2023-04-01');
insert into Customer values('39','Vishal','2','2023-04-02');


# Walk In Customers Table
create table Walk_in_customers (
	Customer_id varchar(20) ,
    Tourism_guide varchar(50) ,
    Timing date, 
    foreign key(Customer_id) references Customer(Customer_id)
);

# Inserting Values into WIC Table
insert into Walk_in_customers values('29', 'Vishal','2023-04-01');
insert into Walk_in_customers values('39', 'Akshata','2023-04-02');

# Mail Order Customers Table
create table Mail_order_customers (
	Customer_id varchar(20) ,
    Post_address varchar(50) ,
    Timing date, 
    foreign key(Customer_id) references Customer(Customer_id)
);


insert into Mail_order_customers values('29', 'Akola', '2023-04-01');
insert into Mail_order_customers values('39', 'Mumbai', '2023-04-02');


# Sales Database
create table Headquarters (
	City_id varchar(20) primary key,
    City_name varchar(50) ,
    Headquarters_addr varchar(50),
    State varchar(20),
    Timing date
);

insert into Headquarters values('1','Akola','Vidharbh','Maharashtra','2023-04-01');
insert into Headquarters values('2','Mumbai','Virar','Maharashtra','2023-04-02');

# Stores Table
create table Stores (
	Store_id varchar(20) primary key,
    City_id varchar(50) ,
    Phone varchar(20),
    Timing date,
    foreign key(City_id) references Headquarters(City_id) 
);

insert into Stores values('1','1','9881221043','2023-04-01');
insert into Stores values('2','2','7506561817','2023-04-02');

# Items Table
create table Items (
	Item_id varchar(20) primary key,
    Description varchar(50) ,
    Size int,
    Weight int,
    Unit_price int,
    Timing date
);

insert into Items values('1','Smart phone',1,1,30000,'2023-04-01');


# Stores Items
create table Stored_Items (
    Store_id varchar(20) ,
	Item_id varchar(20),
	Quantity_held int,
    Timing date,
    primary key(Store_id,Item_id),
    foreign key(Store_id) references Stores(Store_id) ,
    foreign key(Item_id) references Items(Item_id) 
);

insert into Stored_Items values('1','1',13,'2023-04-01');

create table Orders (
    Order_no varchar(20) primary key,
    Order_date date,
    Customer_id varchar(20)
);

insert into Orders values('1','2023-04-01','1');

create table Ordered_Items (
    Order_no varchar(20) ,
	Item_id varchar(20),
	Quantity_ordered int,
    Ordered_price int,
    Timing date,
    primary key(Order_no,Item_id),
    foreign key(Order_no) references Orders(Order_no) ,
    foreign key(Item_id) references Items(Item_id) 
);

insert into Ordered_Items values('1','1',13,30000,'2023-04-01');


# 1 Find all the stores along with city, state, phone, description, size, weight and 
-- unit price that hold a particular item of stock. 
create table Q1(
    City_name varchar(50) ,
    State varchar(20),
    Phone varchar(20),
    Description varchar(50) ,
    Size int,
    Weight int,
    Unit_price int
);

select City_name, State,Phone,Description,Size,Weight,Unit_price from Items,Stores,Headquarters;

insert into Q1 
	select City_name, State,Phone,Description,Size,Weight,Unit_price from Items,Stores,Headquarters;
    

select * from Q1;

# 2 Find all the orders along with customer name and order date that can be 
-- fulfilled by a given store.
create table Q2(
	Store_id varchar(20),
    Order_no varchar(20),
    Customer_name varchar(20),
    Order_date date
);

select Stores.Store_id,Orders.Order_no,Customer_name,Order_date from Stores,Orders,Ordered_items,Customer,Stored_Items where Quantity_ordered <= Quantity_held;

insert into Q2 
select Stores.Store_id,Orders.Order_no,Customer_name,Order_date from Stores,Orders,Ordered_items,Customer,Stored_Items where Quantity_ordered <= Quantity_held;


# 3 Find all stores along with city name and phone that hold items ordered by 
-- given customer.
create table Q3(
	Customer_id varchar(20),
    Store_id varchar(20),
    City_name varchar(20),
    Phone varchar(20)
);

select Customer.Customer_id,Stores.Store_id,City_name,Phone from Orders,Customer,Stored_Items,Stores,Headquarters;

insert into Q3
select Customer.Customer_id,Stores.Store_id,City_name,Phone from Orders,Customer,Stored_Items,Stores,Headquarters;

# 4 Find the headquarter address along with city and state of all stores that hold 
-- stocks of an item above a particular level.
create table Q4(
	City_name varchar(50) ,
    Headquarters_addr varchar(50),
    State varchar(20),
    Quantity_held varchar(20)
);

select City_name,Headquarters_addr,State,Quantity_held from Headquarters,Stored_items;

insert into Q4 
select City_name,Headquarters_addr,State,Quantity_held from Headquarters,Stored_items;

# 5 For each customer order, show the items ordered along with description, store 
-- id and city name and the stores that hold the items.

create table Q5(
	Order_no varchar(20),
    Item_id varchar(20),
    Description varchar(20),
    Store_id varchar(20),
    City_name varchar(20)
);

select Order_no,Item_id,Description,Store_id,City_name
from Orders,((Stored_Items natural join Items) natural join Stores) natural join Headquarters;

insert into Q5
select Order_no,Item_id,Description,Store_id,City_name
from Orders,((Stored_Items natural join Items) natural join Stores) natural join Headquarters;


# 6 Find the city and the state in which a given customer lives.

create table Q6(
	Customer_id varchar(20),
    City_name varchar(20),
    State varchar(20)
);

select Customer_id,City_name,State
from Customer natural join Headquarters;

insert into Q6
select Customer_id,City_name,State
from Customer natural join Headquarters;

# 7. Find the stock level of a particular item in all stores in a particular city
create table Q7(
	Quantity_held int,
    Item_id varchar(20),
    City_name varchar(20)
);

select sum(Quantity_held),Item_id,City_name
from (Stored_items natural join Stores) natural join Headquarters;

insert into Q7
select sum(Quantity_held),Item_id,City_name from (Stored_items natural join Stores) natural join Headquarters;


# 8. Find the items, quantity ordered, customer, store and city of an order.

create table Q8(
	Order_no varchar(20),
    Item_id varchar(20),
    Quantity_ordered int,
    Customer_id varchar(20),
    Store_id varchar(20),
    City_id varchar(20)
);

select Order_no,Item_id,Quantity_ordered,Customer_id,Store_id,City_id
from (Ordered_items natural join Orders natural join Stored_items) natural join Stores;

insert into Q8
select Order_no,Item_id,Quantity_ordered,Customer_id,Store_id,City_id from (Ordered_items natural join Orders natural join Stored_items) natural join Stores;


# 9 Find the walk in customers, mail order customers and dual customers (both 
-- walk-in and mail order).

create table Q9(
	Customer_id varchar(20)
);

select Customer_id
from Walk_in_customers natural join Mail_order_customers;

insert into Q9
select Customer_id
from Walk_in_customers natural join Mail_order_customers;

