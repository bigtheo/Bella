drop database if exists LadyDB;
create database if not exists LadyDB;

use LadyDB;

-- création des tables

create table users
(
Id smallint unsigned not null auto_increment primary key,
name varchar(25) not null,
password varchar(50) not null,
isadmin boolean default false,
created_time timestamp not null default current_timestamp,
last_modofied timestamp not null default current_timestamp,

unique(name,password)
);

create table depenses
(
Id bigint unsigned not null auto_increment primary key,
Designation text not null,
montant decimal not null,
created_time timestamp not null default current_timestamp,
last_modified timestamp not null default current_timestamp,
user_id smallint unsigned not null,

foreign key(user_id) references users(Id)
);

Create table customers
(
id bigint unsigned not null auto_increment primary key,
name varchar(25),
phone varchar(25) not null,
created_time timestamp default current_timestamp,
unique(id),
unique(phone)
);

create table invoices
(
id bigint unsigned not null auto_increment primary key,
customer_id bigint unsigned not null,
created_time timestamp default current_timestamp,
user_id smallint unsigned not null,
description varchar(100) default 'Pas de description',

foreign key(user_id) references users(Id),
foreign key(customer_id) references customers(id)
);

Create table Products
(
id bigint unsigned not null auto_increment primary key,
code_barre varchar(15) not null,
designation varchar(100) not null,
unity varchar(25),
buy_price decimal not null,
unit_price decimal not null,
created_time timestamp default current_timestamp,
unique(code_barre)
);


create table stock
(
id bigint unsigned not null auto_increment primary key,
amount bigint  not null default 0,
operation enum('in','out') default 'in',
created_time timestamp not null default current_timestamp,
product_id bigint unsigned not null,

foreign key(product_id) references products(id)
);


create table Tarifs
(
id bigint unsigned not null auto_increment primary key,
Code varchar(50) not null,
designation varchar(100) not null,
unity_price decimal not null,
created_time timestamp not null default current_timestamp,
unique(designation),
unique(code)
);



create table DetailsFacturePressing
(
id bigint unsigned not null auto_increment primary key,
created_time timestamp not null default current_timestamp,
tarif_id bigint unsigned not null,
invoice_id bigint unsigned not null,
amount bigint unsigned,
negociated_price decimal not null,

foreign key(tarif_id) references tarifs(id),
foreign key(invoice_id) references invoices(id)
);


create table retrait
(
Id bigint unsigned not null auto_increment primary key,
created_time timestamp not null default current_timestamp,
invoice_id bigint unsigned not null,

foreign key(invoice_id) references invoices(id),
unique(invoice_id)
);

create table accoumpte
(
Id bigint unsigned not null auto_increment primary key,
invoice_id bigint unsigned not null,
montant decimal,
created_time timestamp default current_timestamp,

foreign key(invoice_id) references invoices(id)
);