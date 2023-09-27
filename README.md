# postgres_praxis
<details>
<summary> <b>HW4. Оптимизация PostgreSQL</b></summary>
Поднимаем инфраструктуру в YC c помощью terraform в одной ВМ(2 CPU,4Gb). Ставим PostgreSQL на ВМ с использованием Ansible.

```
cd HW4/terraform;
terraform apply;
```
Файл HW4/ansible/inventory заполняется автоматически данными из terraform.  
Ставим PostgreSQL 15 на ВМ с использованием Ansible.  

```
cd ../ansible;
ansible-playbook postgres_install.yml;
ansible-playbook mv_db_postgresql_vm1.yml;
ansible-playbook install_utils.yml;
```
Запускаем инициализацию  
```
pgbench -i -s 50 hw1
```
меняем параметры:  
shared_buffers = 2048MB  
synchronous_commit = off  

проводим тестовый прогон
```
pgbench -c 10 -P 5 -T 60 hw1
```
итог
```
postgres@epdq1i07fnov6p5ekq8f:~$ pgbench -c 10 -P 5 -T 60 hw1
pgbench (15.4 (Ubuntu 15.4-2.pgdg22.04+1))
starting vacuum...end.
progress: 5.0 s, 1806.8 tps, lat 5.490 ms stddev 1.222, 0 failed
progress: 10.0 s, 1898.8 tps, lat 5.265 ms stddev 1.326, 0 failed
progress: 15.0 s, 1949.6 tps, lat 5.128 ms stddev 0.998, 0 failed
progress: 20.0 s, 1896.0 tps, lat 5.272 ms stddev 1.046, 0 failed
progress: 25.0 s, 1900.6 tps, lat 5.260 ms stddev 1.030, 0 failed
progress: 30.0 s, 1906.8 tps, lat 5.242 ms stddev 1.008, 0 failed
progress: 35.0 s, 1907.2 tps, lat 5.241 ms stddev 0.976, 0 failed
progress: 40.0 s, 1926.6 tps, lat 5.191 ms stddev 1.010, 0 failed
progress: 45.0 s, 1964.8 tps, lat 5.088 ms stddev 0.934, 0 failed
progress: 50.0 s, 1925.0 tps, lat 5.193 ms stddev 1.012, 0 failed
progress: 55.0 s, 1892.4 tps, lat 5.283 ms stddev 1.257, 0 failed
progress: 60.0 s, 1872.6 tps, lat 5.338 ms stddev 1.457, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 50
query mode: simple
number of clients: 10
number of threads: 1
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 114246
number of failed transactions: 0 (0.000%)
latency average = 5.248 ms
latency stddev = 1.125 ms
initial connection time = 36.671 ms
tps = 1904.349851 (without initial connection time)
```

Настройки PostgreSQL оптимальны под данный стандартный тест.
</details>

<details>
<summary> <b>HW2</b></summary>
Поднимаем инфраструктуру в YC c помощью terraform в составе двух ВМ. Ставим PostgreSQL на ВМ с использованием Ansible.
Файл HW2/ansible/inventory заполняется автоматически данными из terraform. PostgreSQL - устанавливается на обе виртуальные машины pg-1 и pg-2

```
cd HW2/terraform;  
./infra_up.sh
```  

переносим БД PostgreSQL на виртуальной машине pg-1 на дополнительный диск

```
cd HW2/ansible;
ansible-playbook mv_db_postgresql_pg1.yml
```
останавливаем PostgreSQL и размонтируем disk-2 с нашей БД
```
ansible-playbook stop_db_postgresql_pg1.yml
```
далее надо изменить файл HW2/terraform/main.tf.  
Hаходим блок кода, коментирум его у инстанса pg-1 и добавляем данный диск в инстанс pg-2  
```
secondary_disk {
  disk_id = yandex_compute_disk.disk-2.id
  device_name = "pgdata"
}
```
Далее применяем инфраструктуру
```
cd HW2/terraform;  
terraform apply
```  
монтируем disk-2 и запускаем PostgreSQL с БД на disk-2 на ВМ pg-2 
```
cd HW2/ansible;
ansible-playbook start_db_postgresql_to_pg2.yml
```
</details>
<details>
<summary> <b>HW1</b></summary>
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
</details>

