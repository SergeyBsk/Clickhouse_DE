CREATE DATABASE IF NOT EXISTS restaurant;


CREATE TABLE restaurant.menu (
    id UInt32 COMMENT 'уникальный id блюда',
    category LowCardinality(String) COMMENT 'категория блюда (закуски, основное, напитки)',
    dish_name String COMMENT 'название блюда',
    price Decimal(10, 2) COMMENT 'цена в валюте',
    is_spicy UInt8 DEFAULT 0 COMMENT 'флаг остроты: 0 - нет, 1 - да',
    description Nullable(String) COMMENT 'описание состава'
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO menu (id, category, dish_name, price, is_spicy, description) VALUES
(1, 'Soup', 'Tom Yum', 15.50, 1, 'Classic Thai spicy soup'),
(2, 'Main', 'Carbonara', 12.00, 0, 'Pasta with bacon and egg'),
(3, 'Starter', 'Garlic Bread', 5.50, 0, NULL),
(4, 'Main', 'Curry Chicken', 14.20, 1, 'Indian style chicken'),
(5, 'Drink', 'Lemonade', 3.00, 0, 'Fresh lemon juice');

SELECT * FROM menu FORMAT PrettyCompact;

ALTER TABLE menu UPDATE price = 3.50 WHERE id = 5;


ALTER TABLE menu ADD COLUMN calories UInt16 DEFAULT 0 COMMENT 'Энергетическая ценность';
ALTER TABLE menu DROP COLUMN description;

DESCRIBE TABLE menu;
SELECT * FROM menu LIMIT 2 FORMAT PrettyCompact;

create table avg_by_ct as
select pickup_ct2010, avg(toFloat64(total_amount)) as avg_total_amount
from
s3(
    'https://datasets-documentation.s3.eu-west-3.amazonaws.com/nyc-taxi/trips_{1..2}.gz',
    'TabSeparatedWithNames'
)
group by pickup_ct2010;

CREATE TABLE visits (
    visit_date Date,
    visitor_name String
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(visit_date)
ORDER BY visit_date;

INSERT INTO visits VALUES ('2023-09-01', 'Alice'), ('2023-09-15', 'Bob'); -- Партиция 202309
INSERT INTO visits VALUES ('2023-10-01', 'Charlie'), ('2023-10-20', 'David'); -- Партиция 202310

SELECT partition, name, rows FROM system.parts WHERE table = 'visits';

ALTER TABLE visits DETACH PARTITION 202309;
SELECT * FROM visits;
ALTER TABLE visits ATTACH PARTITION 202309;
SELECT * FROM visits;
ALTER TABLE visits DROP PARTITION 202310;
SELECT * FROM visits;
