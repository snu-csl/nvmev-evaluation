LOAD DATA LOCAL INFILE '../data/customer.csv' INTO TABLE CUSTOMER FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE '../data/orders.csv' INTO TABLE ORDERS FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE '../data/lineitem.csv' INTO TABLE LINEITEM FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE '../data/nation.csv' INTO TABLE NATION FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE '../data/partsupp.csv' INTO TABLE PARTSUPP FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE '../data/part.csv' INTO TABLE PART FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE '../data/region.csv' INTO TABLE REGION FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE '../data/supplier.csv' INTO TABLE SUPPLIER FIELDS TERMINATED BY '|';
