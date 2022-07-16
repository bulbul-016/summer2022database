CREATE table dealer (
    id integer primary key,
    name varchar(255),
    locatiON varchar(255),
    charge float
);

INSERT INTO dealer (id, name, locatiON, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, locatiON, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, locatiON, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, locatiON, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, locatiON, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, locatiON, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

CREATE table client (
    id integer primary key,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

CREATE table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

------------------------------------------------------------------------------------------------------------------------
-- 1.a
SELECT * FROM dealer INNER JOIN client ON dealer.id = client.dealer_id;

-- 1.b
SELECT d, c.name, c.city, c.priority, s.id, s.date, s.amount FROM dealer d
LEFT JOIN client c ON d.id = c.dealer_id
LEFT JOIN sell s ON c.id = s.client_id
WHERE c.name IS NOT NULL AND c.city IS NOT NULL
AND c.priority IS NOT NULL
AND s.id IS NOT NULL
AND s.date IS NOT NULL
AND s.amount IS NOT NULL ;

-- 1.c
SELECT d, c FROM dealer d
INNER JOIN client c ON c.city = d.locatiON;

-- 1.d
SELECT s.id, s.amount, c.name, c.city FROM sell s
INNER JOIN client c ON s.client_id = c.id
WHERE s.amount >= 100 AND s.amount <= 500;

-- 1.e
SELECT * FROM dealer d LEFT JOIN client c ON d.locatiON = c.city;

-- 1.f
SELECT c.name, c.city, d.name, d.charge FROM client c JOIN dealer d ON c.dealer_id = d.id;

-- 1.g
SELECT c.name, c.city, d FROM client c JOIN dealer d ON dealer_id = d.id
WHERE d.charge > 0.12;

-- 1.h
SELECT c.name, c.city, s.id, s.date, s.amount, d.name, d.charge FROM client c
JOIN dealer d ON c.dealer_id = d.id
JOIN sell s ON c.id = s.client_id;

-- 1.i
SELECT client.name,client.city, client.priority,dealer.name, sell.id,sell.amount
FROM client RIGHT OUTER JOIN dealer ON client.dealer_id = dealer.id
    LEFT OUTER JOIN sell ON client.id = sell.client_id
WHERE amount >= 2000 AND client.priority IS NOT NULL;

-- 2.a
CREATE VIEW cass
AS SELECT s.date, count(distinct s.client_id), avg(s.amount), sum(s.amount) FROM sell s GROUP BY s.date;

-- 2.b
CREATE VIEW abcd
AS SELECT s.date, s.amount FROM sell s
ORDER BY s.amount desc limit 5;

-- 2.c
CREATE VIEW casd
AS SELECT d, count(s.amount), avg(s.amount), sum(s.amount) FROM sell s
JOIN dealer d ON d.id = s.dealer_id GROUP BY d;

-- 2.d
CREATE VIEW sd
AS SELECT d, sum(amount * d.charge) FROM sell s
JOIN dealer d ON d.id = s.dealer_id GROUP BY d;

-- 2.e
CREATE VIEW casej
AS SELECT d.locatiON, count(s.amount), avg(s.amount), sum(s.amount) FROM dealer d
JOIN sell s ON d.id = s.dealer_id GROUP BY d.locatiON;

-- 2.f
CREATE VIEW casef
AS SELECT c.city, count(s.amount), avg(s.amount * (d.charge + 1)), sum(s.amount * (d.charge + 1)) FROM client c
JOIN dealer d ON c.dealer_id = d.id
JOIN sell s ON c.id = s.client_id GROUP BY c.city;

-- 2.g
CREATE VIEW gg
AS SELECT c.city, sum(s.amount * (d.charge + 1)) AS totalexpense, sum(s.amount) AS totalamount FROM client c
JOIN sell s ON c.id = s.client_id
JOIN dealer d ON s.dealer_id = d.id AND c.city = d.locatiON GROUP BY c.city;

drop VIEW cass;
drop VIEW abcd;
drop VIEW casd;
drop VIEW sd;
drop VIEW casej;
drop VIEW casef;
drop VIEW gg;
