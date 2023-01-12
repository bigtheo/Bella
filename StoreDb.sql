drop database if exists stroreDb;
create  database if not exists stroreDb;
use stroreDb;


create table if not exists Users (
id smallint unsigned not null auto_increment primary key, 
name varchar(30) not null,
 password varchar(50) not null, 
 isAdmin boolean default false, 
 isBlocked boolean default false);



create table if not exists Product 
(id bigint unsigned not null auto_increment primary key
 ,barre_code varchar(20) not null
 , name varchar(100) not null
 , created_time timestamp not null default current_timestamp
 , sell_price decimal not null check(sell_price>0),
 amount bigint unsigned default 0,
 unique(barre_code)
 ); 


create table if not exists Customer (
id bigint unsigned not null auto_increment primary key
, name varchar(50)
, phone varchar(15)
, created_time timestamp default current_timestamp,
unique(phone)
);

create table if not exists Invoice (
id bigint unsigned not null auto_increment primary key
, created_time timestamp not null default current_timestamp

, customer_id bigint unsigned 
, user_id smallint unsigned,

foreign  key(customer_id) references customer(id) on update cascade on delete set null,
foreign  key(user_id) references users(id) on update cascade on delete set null
);

drop table if exists InvoiceLine;
create table if not exists InvoiceLine (
id bigint unsigned not null auto_increment primary key,
invoice_id bigint unsigned not null ,
 product_id bigint unsigned not null,
 amount int not null check(amount >0), 
 negociated_price decimal not null check(negociated_price>0),
 created_time timestamp not null default current_timestamp
 );
 
 

 drop table if exists EntreeStock;
  create table EntreeStock(
 id bigint unsigned not null auto_increment not null primary key,
 amount bigint unsigned not null check(amount >0),
 code_article varchar(10),
 created_time timestamp default current_timestamp,
 foreign key(code_article) references product(barre_code)
 
 );
 
 
 drop table if exists SortieStock;
  create table SortieStock(
 id bigint unsigned not null auto_increment not null primary key,
 amount bigint unsigned not null check(amount >0),
 code_article varchar(10),
 created_time timestamp default current_timestamp,
 foreign key(code_article) references product(barre_code)
 
 );
 
 
 
 -- triger entree MAGASIN  
 drop trigger if exists afterInsertEntreeStock;
 delimiter |
 create trigger afterInsertEntreeStock after insert on EntreeStock for each row
 begin 
 
 update product set amount = amount + new.amount where barre_code=new.code_article;
 
 end |
 
 
 delimiter ;
 
  -- triger Sortie MAGASIN  
 drop trigger if exists afterInsertSortieStock;
 delimiter |
 create trigger afterInsertSortieStock after insert on  InvoiceLine for each row
 begin 
 declare v_code varchar(10) ;
 
 select barre_code into v_code from product where id = new.product_id;
 
 update product set amount = amount - new.amount where barre_code=v_code;
 insert into SortieStock(amount,code_article) values (new.amount,v_code);
 
 end |
 
 
 delimiter ;
 

 
  
 -- stock lavage 
 drop table if exists ArticleLavage;
 create table ArticleLavage(
 
 id bigint unsigned not null auto_increment primary key,
 code varchar(10) not null,
 name varchar(50) not null,
 marque varchar(50),
 amount bigint unsigned not null check(amount>0),
 Observation varchar(50),
 unique(code),
 created_time timestamp default current_timestamp
 
 );
 
 create table EntreeStockLavage(
 id bigint unsigned not null auto_increment not null primary key,
 amount bigint unsigned not null check(amount >0),
 code_article varchar(10),
 created_time timestamp default current_timestamp,
 foreign key(code_article) references ArticleLavage(code)
 
 );
 
 drop table if exists SortieStockLavage;
  create table SortieStockLavage(
 id bigint unsigned not null auto_increment not null primary key,
 amount bigint unsigned not null check(amount >0),
 code_article varchar(10),
 created_time timestamp default current_timestamp,
 foreign key(code_article) references ArticleLavage(code) on delete set null
 
 );
 
 
 -- triger entree MAGASIN LAVAGE 
 drop trigger if exists afterInsertEntreeStockLavage;
 delimiter |
 create trigger afterInsertEntreeStockLavage after insert on EntreeStockLavage for each row
 begin 
 
 update ArticleLavage set amount = amount + new.amount where code=new.code_article;
 
 end |
 
 
 delimiter ;
 
  -- triger Sortie MAGASIN LAVAGE 
 drop trigger if exists afterInsertSortieStockLavage;
 delimiter |
 create trigger afterInsertSortieStockLavage after insert on SortieStockLavage for each row
 begin 
 
 update ArticleLavage set amount = amount - new.amount where code=new.code_article;
 
 end |
 
 
 delimiter ;
 
 
 
 
 
 insert into users(name,password,isAdmin,IsBlocked) values('kapapa',sha1('1993'),true,false);