create role artyom_fadeyev with login password 'artyom_fadeyev' nosuperuser;

create role itmo_users nologin nocreatedb nocreaterole nosuperuser;
create role itmo_readers nologin nocreatedb nocreaterole nosuperuser;

create role itmo_user_1 with login password 'itmo_user_1';
create role itmo_reader_1 with login password 'itmo_reader_1';

grant itmo_users to itmo_user_1;
grant itmo_readers to itmo_reader_1;

create database artyom_fadeyev_db with owner artyom_fadeyev;

\c artyom_fadeyev_db artyom_fadeyev

create table table_1
(
    id   serial primary key,
    name varchar(100)
);

insert into table_1 (name)
values ('name_1'),
       ('name_2'),
       ('name_3');

create table table_2
(
    id     serial primary key,
    income integer
);

insert into table_2 (income)
values (100),
       (200),
       (300);

revoke all on database artyom_fadeyev_db from group itmo_users, itmo_readers;
grant connect on database artyom_fadeyev_db to group itmo_users, itmo_readers;
grant select, insert, update, delete on all tables in schema public to itmo_users;
grant select on all tables in schema public to itmo_readers;

\c artyom_fadeyev_db itmo_user_1

-- insert is allowed for itmo_user_1
insert into table_1 (id, name)
values (4, 'name_4');

-- allowed to create and drop your own tables
create table table_3
(
    id   serial primary key,
    name varchar(100)
);

\c artyom_fadeyev_db itmo_reader_1

select *
from table_1;

-- insert is not allowed for itmo_reader_1
insert into table_1 (id, name)
values (5, 'name_5');

-- allowed to create and drop your own tables
create table table_4
(
    id     serial primary key,
    income integer
);