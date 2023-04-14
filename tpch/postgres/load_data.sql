\timing on

TRUNCATE TABLE part;
TRUNCATE TABLE region;
TRUNCATE TABLE nation;
TRUNCATE TABLE supplier;
TRUNCATE TABLE customer;
TRUNCATE TABLE partsupp;
TRUNCATE TABLE orders;
TRUNCATE TABLE lineitem;

\COPY part FROM '../data/part.csv' WITH (FORMAT csv, DELIMITER '|');
\COPY region FROM '../data/region.csv' WITH (FORMAT csv, DELIMITER '|');
\COPY nation FROM '../data/nation.csv' WITH (FORMAT csv, DELIMITER '|');
\COPY supplier FROM '../data/supplier.csv' WITH (FORMAT csv, DELIMITER '|');
\COPY customer FROM '../data/customer.csv' WITH (FORMAT csv, DELIMITER '|');
\COPY partsupp FROM '../data/partsupp.csv' WITH (FORMAT csv, DELIMITER '|');
\COPY orders FROM '../data/orders.csv' WITH (FORMAT csv, DELIMITER '|');
\COPY lineitem FROM '../data/lineitem.csv' WITH (FORMAT csv, DELIMITER '|');
