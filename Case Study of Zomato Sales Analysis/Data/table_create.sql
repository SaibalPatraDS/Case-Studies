/* Creating tables for zomato_data_analysis */

CREATE TABLE zomato.goldusers_signup (
	USER_ID INTEGER,
	signup_date DATE
);

INSERT INTO zomato.goldusers_signup VALUES (1, '22-09-2017'), 
                                    (2, '21-04-2017');
									
									
									
									
CREATE TABLE zomato.users (
	USER_ID INTEGER,
	signup_date DATE
);


INSERT INTO zomato.users VALUES (1, '02-09-2014'),
                         (2, '05-01-2015'),
						 (3, '11-04-2014');
					
									
CREATE TABLE zomato.sales(USER_ID integer,created_date date,PRODUCT_ID integer); 

INSERT INTO zomato.sales(USER_ID,created_date,PRODUCT_ID) VALUES 
(1,'19-04-2017',2),
(3,'18-12-2019',1),
(2,'20-07-2020',3),
(1,'23-10-2019',2),
(1,'19-03-2018',3),
(3,'20-12-2016',2),
(1,'09-11-2016',1),
(1,'20-05-2016',3),
(2,'24-09-2017',1),
(1,'11-03-2017',2),
(1,'11-03-2016',1),
(3,'10-11-2016',1),
(3,'07-12-2017',2),
(3,'15-12-2016',2),
(2,'08-11-2017',2),
(2,'10-09-2018',3);									
									


CREATE TABLE zomato.products (
	PRODUCT_ID INTEGER,
	product_name VARCHAR,
	price NUMERIC
);

INSERT INTO zomato.products(PRODUCT_ID,product_name,price) VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);






















									
									