
drop table if exists derrogation;

create table derrogation
(
Id smallint unsigned not null auto_increment primary key,
eleve_id smallint unsigned not null,
jour smallint unsigned not null,
created_time timestamp default current_timestamp,
unique(eleve_id),

foreign key(eleve_id) references eleve(id)
);