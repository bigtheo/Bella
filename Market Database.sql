drop database if exists ite_sells;
create  database if not exists ite_sells;
use ite_sells;


create table if not exists Users (
id smallint unsigned not null auto_increment primary key, 
name varchar(30) not null,
 password varchar(50) not null, 
 isAdmin boolean default false, 
 isBlocked boolean default false);

create table if not exists Fournisseur 
(id smallint unsigned not null auto_increment primary key
, name varchar(50) not null
,adress varchar(50)
,phone char(15)
,created_time timestamp default current_timestamp,
unique(phone)
 );

create table if not exists Category (
id smallint unsigned not null auto_increment primary key,
code varchar(10) not null
,name varchar(50) not null
 ,created_time timestamp default current_timestamp
 ,unique(code)
);

drop table if exists armoire;
create table if not exists Armoire (
id smallint unsigned not null auto_increment primary key,
code varchar(10) not null
, name varchar(50) not null
, created_time timestamp not null default current_timestamp,
unique(name),
unique(code)
); 

create table if not exists Product 
(id bigint unsigned not null auto_increment primary key
 ,barre_code varchar(20) not null
 , name varchar(100) not null
 ,category_code varchar(10) 
 , created_time timestamp not null default current_timestamp
 , buy_price decimal not null check(buy_price>0)
 , sell_price decimal not null check(sell_price>0)
 , fournisseur_id smallint unsigned ,
 
 foreign key(category_code) references category(code) on delete set null on update cascade,
 foreign key(fournisseur_id) references Fournisseur(id) on delete set null on update cascade,
 unique(barre_code)
 ); 

create table StoreOperation (id bigint unsigned not null auto_increment primary key, 
type enum('in', 'out'), 
amount int not null check(amount > 0)

,Code_barre varchar(20) not null
,code_armoire varchar(10) not null,
created_time timestamp default current_timestamp,
 
 foreign key(Code_barre) references product(barre_code) on update cascade,
 foreign key(code_armoire) references armoire(code) on update cascade
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
 
 
 
 insert into users(name,password,isAdmin,IsBlocked) values('kapapa',sha1('1993'),true,false);