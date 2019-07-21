--- Create tables for calculations---

create table Suppliers (supplierid int, name varchar(30), rating integer, city varchar(30));
INSERT INTO Suppliers (supplierid, name, rating, city) VALUES 
(1,'Smith', 20, 'London'),
(2,'Jonth', 10, 'Paris'),
(3,'Blacke', 30, 'Paris'),
(4,'Clarck', 20, 'London'),
(5,'Adams', 30, 'Athens');
select * from Suppliers;

create table Details (detailid int, name varchar(30), color varchar(30),weight integer, city varchar(30));
INSERT INTO Details (detailid, name, color, weight, city) VALUES 
(1,'Screw', 'Red', 12, 'London'),
(2,'Bolt', 'Green', 17, 'Paris'),
(3,'Male-screw', 'Blue', 17, 'Roma'),
(4,'Male-screw', 'Red', 14, 'London'),
(5,'Whell', 'Blue', 12, 'Paris'),
(6,'Bloom', 'Red', 19, 'London');
select * from Details;

create table Products (Productid int, name varchar(30), city varchar(30));
INSERT INTO Products (Productid, name, city) VALUES 
(1,'HDD', 'Paris'),
(2,'Perforator', 'Roma'),
(3,'Reader', 'Athens'),
(4,'Printer', 'Athens'),
(5,'FDD', 'London'),
(6,'Terminal', 'Oslo'),
(7,'Ribbon', 'London');
select * from Products;

create table Supplies (supplierid int, detailid integer, Productid integer,quantity integer);
INSERT INTO Supplies (supplierid, detailid, Productid, quantity) VALUES 
(1,1,1,200),
(1,1,4,700),
(2,3,1,400),
(2,3,2,200),
(2,3,3,200),
(2,3,4,500),
(2,3,5,600),
(2,3,6,400),
(2,3,7,800),
(2,5,2,100),
(3,3,1,200),
(3,4,2,500),
(4,6,3,300),
(4,6,7,300),
(5,2,2,200),
(5,2,4,100),
(5,5,5,500),
(5,5,7,100),
(5,6,2,200),
(5,1,4,100),
(5,3,4,200),
(5,4,4,800),
(5,5,4,400),
(5,6,4,500);

-a
select rs.productid from (select s.productid, s.detailid from supplies s 
where s.supplierid=3 ) rs group by rs.detailid, rs.productid;
                                                                     
Отримати номери виробів, для яких всі деталі постачає постачальник 3   
select productid from supplies where detailid=3 and                                                                      
-b
select supplierid from supplies where quantity > (select avg(quantity) from supplies where detailid=1)

SELECT distinct suppliers.supplierid, name
FROM suppliers JOIN supplies s_out on suppliers.supplierid = s_out.supplierid
WHERE detailid = 1 AND quantity> 
(SELECT AVG(s_in.quantity) FROM supplies s_in WHERE s_in.detailid=s_out.detailid AND s_in.detailid=1)
--c.
select distinct detailid from supplies where productid in (select productid from products where city = 'London');
--d.
select supplierid, name from Suppliers where supplierid in (select supplierid from supplies where detailid in (select detailid from details where color = 'red'));
-e
select productid from supplies where supplierid = 2 group by productid having count (detailid)>1
-f
select productid from supplies group by productid having avg(quantity) > (select Max(quantity) from supplies where productid=1)
--g.
select productid from products where productid not in (select distinct productid from supplies);

--1
WITH CTE2 AS (SELECT name FROM geography where name like 'R%'),
CTE3 AS (SELECT name FROM CTE2 where name like '%e')
SELECT name FROM CTE3;
--2
;WITH r AS (SELECT 
1 AS i, 1 AS factorial
UNION all
SELECT i+1 AS i,  factorial * (i+1) as factorial FROM r WHERE i <10)
SELECT i as Position, factorial as Value FROM r where i=10 ;
--3--
;with fibo as (
    select 0 as fibA, 1 as fibB, 1 as seed, 1 as  num
    union all
    select seed+fibA, fibA+fibB, fibA, num+1
    from fibo
    where num<21)
select num-1 as Position, fibA as Value
from fibo where fibA>=1
--4
DECLARE @BeginPeriod DATETIME = '2013-11-25',
        @EndPeriod DATETIME = '2014-03-05'
;WITH cte AS
(SELECT DATEADD(month, DATEDIFF(month, 0, @BeginPeriod), 0) AS StartOfMonth, 
DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @BeginPeriod) + 1, 0)) AS EndOfMonth
    UNION ALL
SELECT DATEADD(month, 1, StartOfMonth) AS StartOfMonth, 
DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, DATEADD(month, 1, StartOfMonth)) + 1, 0)) AS EndOfMonth  
FROM   cte WHERE  DATEADD(month, 1, StartOfMonth) <= @EndPeriod)
SELECT  
(CASE WHEN StartOfMonth < @BeginPeriod THEN @BeginPeriod ELSE StartOfMonth END) StartOfMonth,
(CASE WHEN EndOfMonth > @EndPeriod THEN @EndPeriod ELSE EndOfMonth END) EndOfMonth
FROM cte


-5
declare @date as date = dateadd(mm,-1,getdate())
;with cte as (select dateadd(dd,1,eomonth(dateadd(mm,-1,@date))) firstofmonth, eomonth(@date) endofmonth), cte1 as (select dateadd(dd, -1 * (case datepart(weekday, firstofmonth) when 1 then 6
else datepart(weekday, firstofmonth) - 2 end), firstofmonth) previousmonday,
firstofmonth, endofmonth, case when datepart(dw,endofmonth) = 1 then endofmonth
else dateadd(dd, 8 - datepart(dw,endofmonth), endofmonth)  end as lastsunday from cte), cte2 as (
select 1 cnt, previousmonday as calendarday, lastsunday from cte1
union all
select cnt+1, dateadd(dd, 1, calendarday) as calendarday, lastsunday from cte2 where dateadd(dd, 1, calendarday) <= lastsunday), 
calendar as (select cnt, ((cnt-1)/7)+1 weeknumber, calendarday, datename(dw,calendarday) nameofday,
 case when (cnt % 7) = 1 and month(calendarday) = month(@date) then cast(calendarday as varchar) else '' end as Monday,
 case when (cnt % 7) = 2 and month(calendarday) = month(@date) then cast(calendarday as varchar) else '' end as Tuesday,
 case when (cnt % 7) = 3 and month(calendarday) = month(@date) then cast(calendarday as varchar) else '' end as Wednesday,
 case when (cnt % 7) = 4 and month(calendarday) = month(@date) then cast(calendarday as varchar) else '' end as Thursday,
 case when (cnt % 7) = 5 and month(calendarday) = month(@date) then cast(calendarday as varchar) else '' end as Friday,
 case when (cnt % 7) = 6 and month(calendarday) = month(@date) then cast(calendarday as varchar) else '' end as Saturday,
 case when (cnt % 7) = 0 and month(calendarday) = month(@date) then cast(calendarday as varchar) else '' end as Sunday from cte2)
select
 max(Monday) Monday,max(Tuesday) Tuesday,max(Wednesday) Wednesday,max(Thursday) Thursday,max(Friday) Friday,max(Saturday) Saturday,
 max(Sunday) Sunday from calendar group by weeknumber;


--1--
create table [geography]
(id int not null primary key, name varchar(20), region_id int);
ALTER TABLE [geography] ADD CONSTRAINT R_GB FOREIGN KEY (region_id) REFERENCES [geography]  (id);
insert into [geography] values (1, 'Ukraine', null);
insert into [geography] values (2, 'Lviv', 1);
insert into [geography] values (8, 'Brody', 2);
insert into [geography] values (18, 'Gayi', 8);
insert into [geography] values (9, 'Sambir', 2);
insert into [geography] values (17, 'St.Sambir', 9);
insert into [geography] values (10, 'Striy', 2);
insert into [geography] values (11, 'Drogobych', 2);
insert into [geography] values (15, 'Shidnytsja', 11);
insert into [geography] values (16, 'Truskavets', 11);
insert into [geography] values (12, 'Busk', 2);
insert into [geography] values (13, 'Olesko', 12);
insert into [geography] values (30, 'Lvivska st', 13);
insert into [geography] values (14, 'Verbljany', 12);
insert into [geography] values (3, 'Rivne', 1);
insert into [geography] values (19, 'Dubno', 3);
insert into [geography] values (31, 'Lvivska st', 19);
insert into [geography] values (20, 'Zdolbuniv', 3);
insert into [geography] values (4, 'Ivano-Frankivsk', 1);
insert into [geography] values (21, 'Galych', 4);
insert into [geography] values (32, 'Svobody st', 21);
insert into [geography] values (22, 'Kalush', 4);
insert into [geography] values (23, 'Dolyna', 4);
insert into [geography] values (5, 'Kiyv', 1);
insert into [geography] values (24, 'Boryspil', 5);
insert into [geography] values (25, 'Vasylkiv', 5);
insert into [geography] values (6, 'Sumy', 1);
insert into [geography] values (26, 'Shostka', 6);
insert into [geography] values (27, 'Trostjanets', 6);
insert into [geography] values (7, 'Crimea', 1);
insert into [geography] values (28, 'Yalta', 7);
insert into [geography] values (29, 'Sudack', 7);
select * from geography;
--2--
;WITH CTE4 (region_id, place_id, name, Placelevel) AS
(SELECT region_id, id, name, Placelevel=1 FROM geography WHERE REGION_ID=1)
SELECT * FROM CTE4;
--3--
;WITH CTE5(region_id, place_id, name, Placelevel) AS
(SELECT region_id, id, name, Placelevel=-1 FROM geography 
WHERE name='Ivano-Frankivsk' UNION ALL
SELECT g.region_id, g.id, g.name, f.Placelevel+1 FROM geography g 
INNER JOIN CTE5 f ON g.region_id=f.place_id)
SELECT region_id, place_id, name, Placelevel FROM CTE5 WHERE Placelevel>=0;
--4
;  with cte6 (depid, name, region_id, level) as
  (select id as depid, name, region_id, 0 as level
  from geography where region_id is null union all
  select d.id as depid, d.name, d.region_id, cte6.level+1 as level
  from geography d inner join cte6 on cte6.depid=d.region_id)
select name, level from cte6; 
--5
;  with cte6 (depid, name, region_id, level) as
  (select id as depid, name, region_id, 1 as level
  from geography where name='Lviv' union all
  select d.id as depid, d.name, d.region_id, cte6.level+1 as level
  from geography d inner join cte6 on cte6.depid=d.region_id)
select name, depid, region_id, level from cte6 where region_id>=1; 
--6
;  with cte6 (depid, name, region_id, level, treepath) as
  (select id as depid, name, region_id, 1 as level, cast('/'+name as varchar(1024)) as treepath
  from geography where name='Lviv' union all
  select d.id as depid, d.name, d.region_id, cte6.level+1 as level,
  cast(cte6.treepath+'/'+cast(d.name as varchar(1024)) as varchar(1024)) as treepath
  from geography d inner join cte6 on cte6.depid=d.region_id)
select name, level as id, treepath as path from cte6 order by treepath;  
--7
;  with cte7 (depid, name, region_id, level, treepath) as
  (select id as depid, name, region_id, 0 as level, cast('/'+name as varchar(1024)) as treepath
  from geography where name='Lviv' union all
  select d.id as depid, d.name, d.region_id, cte7.level+1 as level,
  cast(cte7.treepath+'/'+cast(d.name as varchar(1024)) as varchar(1024)) as treepath
  from geography d inner join cte7 on cte7.depid=d.region_id)
select name, name='Lviv',level as pathlen, treepath as path  from cte7 where level>=1;

--1
select supplierid from suppliers where city = 'London'
union 
select supplierid from suppliers where city = 'Paris';
--2
--with dublicates
select city from suppliers 
union all
select city from details
--without dublicates
select city from suppliers 
union 
select city from details
--3.  
select supplierid from suppliers except select supplierid from supplies where detailid in (select detailid from details where city = 'London');
-4.
select * from supplies inner join products on supplies.productid=products.productid where city ='London' or city ='Paris'
intersect
select * from supplies inner join products on supplies.productid=products.productid where city ='Paris' or city ='Rome'
SELECT X.city FROM
(SELECT ROW_NUMBER() OVER(PARTITION BY city ORDER BY (SELECT 0)) AS RN
      ,city FROM suppliers
INTERSECT
SELECT ROW_NUMBER() OVER(PARTITION BY city ORDER BY (SELECT 0)) AS RN
      ,city FROM details
) AS X
ORDER BY 1
                                                --5
select supplierid, detailid, productid from supplies where 
supplierid in (select supplierid from suppliers where city = 'london') 
or detailid in (select detailid from details where color='green') 
except select supplierid, detailid, productid from supplies where productid in (select productid from products where city='paris');



