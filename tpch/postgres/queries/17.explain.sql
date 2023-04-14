\timing on
-- using 1489058137 as a seed to the RNG


explain select
	sum(l_extendedprice) / 7.0 as avg_yearly
from
	lineitem,
	part,
	(SELECT l_partkey AS agg_partkey, 0.2 * avg(l_quantity) AS avg_quantity FROM lineitem GROUP BY l_partkey) part_agg
where
	p_partkey = l_partkey
	and agg_partkey = l_partkey
	and p_brand = 'Brand#54'
	and p_container = 'JUMBO BAG'
	and l_quantity < avg_quantity
LIMIT 1;
