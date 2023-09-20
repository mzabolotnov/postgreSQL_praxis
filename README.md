# postgres_praxis
## HW1

Поднимаем инфраструктуру в YC c помощью terraform в составе одной ВМ. Ставим PostgreSQL на ВМ с использованием Ansible.  
```
cd HW1/terraform;  
./infra_up.sh
```  
подключаемся к ВМ 
```
ssh -i ~/.ssh/appuser ubuntu@<IP address- ВМ>
```
заходим в нашу созданную БД hw1
```
psql -U postgres -d hw1
```
смотрим текущий уровень изоляции
```
show transaction isolation level
```

    transaction_isolation
    -----------------------
    read committed
    (1 row)

создаем таблицу
```
create table persons(id serial, first_name text, second_name text);
insert into persons(first_name, second_name) values('ivan', 'ivanov');
insert into persons(first_name, second_name) values('petr', 'petrov');
commit;
```

подключаемся к PostgreSQL второй сессией
текущий уровень изоляции по умолчанию
```
show transaction isolation level
```
    transaction_isolation
    -----------------------
    read committed

отключаем autocommit во второй сессии
```
\set AUTOCOMMIT off
```
В первой сессии также отключаем autocommit
```
\set AUTOCOMMIT off
```
добавляем еще одну строку в первой сессии
```
insert into persons(first_name, second_name) values('sergey', 'sergeev');
```
если попробовать прочитать таблицу persons во второй сессии
```
select * from persons;
```
мы не увидим новой записи, т.к. Postgres не допускает грязного чтения незакомиченных изменений.
делаем в первой сессии
```
commit;
```
тогда во второй открытой сессии мы увидим новую запись. уровень изоляции read committed позволяет сделать это
Завершаем транзакцию во второй сессии
```commit;
```

Меняем уровень изоляции в первой и второй сессии
```
set transaction isolation level repeatable read;
```
делаем вставку строки в первой сессии
```
insert into persons(first_name, second_name) values('sveta', 'svetova');
```
и закрываем транзакцию в первой сессии
```
commit;
```
при измененном уровне изоляции *repeatable read
мы не увидим новой строки во второй сессии, пока не закроем транзакцию во второй сессии.

hw1=*# select * from persons;  
 id | first_name | second_name  
----+------------+-------------  
  1 | ivan       | ivanov  
  2 | petr       | petrov  
  8 | sergey     | sergeev  
(3 rows)  

hw1=*# commit;  
COMMIT  
hw1=# select * from persons;  
 id | first_name | second_name  
----+------------+-------------  
  1 | ivan       | ivanov  
  2 | petr       | petrov  
  8 | sergey     | sergeev  
 10 | sveta      | svetova  
(4 rows)  

