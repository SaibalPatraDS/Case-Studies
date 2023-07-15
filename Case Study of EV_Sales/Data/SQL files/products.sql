CREATE TABLE ev_sales.products(
   product_id            INTEGER  NOT NULL PRIMARY KEY 
  ,model                 VARCHAR(22) NOT NULL
  ,year                  VARCHAR  NOT NULL
  ,product_type          VARCHAR(10) NOT NULL
  ,base_price            INTEGER  NOT NULL
  ,production_start_date DATE  NOT NULL
  ,production_end_date   DATE 
);
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (1,'FioNex','2010','scooter',63998,'03-03-2010 00:00','08-06-2012 00:00');
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (2,'FioNex Limited Edition','2011','scooter',127998,'03-01-2011 00:00','30-03-2011 00:00');
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (3,'FioNex','2013','scooter',79998,'01-05-2013 00:00','28-12-2018 00:00');
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (4,'DeltaPlus','2014','automobile',920000,'23-06-2014 00:00','28-12-2018 00:00');
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (5,'Parker','2014','scooter',111998,'23-06-2014 00:00','27-01-2015 00:00');
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (6,'Corpel','2015','automobile',524000,'15-04-2015 00:00','01-10-2018 00:00');
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (7,'Sprint','2016','scooter',95998,'10-10-2016 00:00',NULL);
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (8,'Sprint Limited Edition','2017','scooter',111998,'15-02-2017 00:00',NULL);
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (9,'SigniaSafari','2017','automobile',280000,'15-02-2017 00:00',NULL);
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (10,'Zelito800','2017','automobile',686000,'15-02-2017 00:00',NULL);
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (11,'DeltaPlus','2019','automobile',760000,'04-02-2019 00:00',NULL);
INSERT INTO ev_sales.products(product_id,model,year,product_type,base_price,production_start_date,production_end_date) VALUES (12,'FioNex Zester','2019','scooter',55998,'04-02-2019 00:00',NULL);
