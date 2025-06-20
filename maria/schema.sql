CREATE TABLE users(
 username varchar(255) not null,
 password varchar(255) not null,
 id int(8) not null auto_increment,
 primary key(id)
) engine=innodb default charset=utf8;
