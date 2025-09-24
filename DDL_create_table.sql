-- Таблица мастеров
DROP TABLE IF EXISTS dwh.d_craftsman;
CREATE TABLE IF NOT EXISTS dwh.d_craftsman (
    craftsman_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    craftsman_name VARCHAR NOT NULL,
    craftsman_address VARCHAR NOT NULL,
    craftsman_birthday DATE NOT NULL,
    craftsman_email VARCHAR NOT NULL,
    load_dttm TIMESTAMP NOT NULL DEFAULT current_timestamp,
    CONSTRAINT d_craftsman_pk PRIMARY KEY (craftsman_id)
);

-- Таблица продуктов
DROP TABLE IF EXISTS dwh.d_product;
CREATE TABLE IF NOT EXISTS dwh.d_product (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    product_name VARCHAR NOT NULL,
    product_description VARCHAR NOT NULL,
    product_type VARCHAR NOT NULL,
    product_price NUMERIC(15,2) NOT NULL,
    load_dttm TIMESTAMP NOT NULL DEFAULT current_timestamp,
    CONSTRAINT d_product_pk PRIMARY KEY (product_id)
);

-- Таблица клиентов
DROP TABLE IF EXISTS dwh.d_customer;
CREATE TABLE IF NOT EXISTS dwh.d_customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    customer_name VARCHAR NOT NULL,
    customer_address VARCHAR NOT NULL,
    customer_birthday DATE NOT NULL,
    customer_email VARCHAR NOT NULL,
    load_dttm TIMESTAMP NOT NULL DEFAULT current_timestamp,
    CONSTRAINT d_customer_pk PRIMARY KEY (customer_id)
);

-- Таблица заказов
DROP TABLE IF EXISTS dwh.f_order;
CREATE TABLE IF NOT EXISTS dwh.f_order (
    order_id BIGINT NOT NULL,
    order_created_date TIMESTAMP NOT NULL,
    order_completion_date TIMESTAMP,
    order_status VARCHAR(50) NOT NULL,
    craftsman_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    load_dttm TIMESTAMP NOT NULL DEFAULT current_timestamp,
    CONSTRAINT f_order_pk PRIMARY KEY (order_id),
    CONSTRAINT f_order_craftsman_fk FOREIGN KEY (craftsman_id) REFERENCES dwh.d_craftsman(craftsman_id),
    CONSTRAINT f_order_customer_fk FOREIGN KEY (customer_id) REFERENCES dwh.d_customer(customer_id),
    CONSTRAINT f_order_product_fk FOREIGN KEY (product_id) REFERENCES dwh.d_product(product_id)
);

-- таблица инкрементального обновления витрины, записывает дату последнего обновления
DROP TABLE IF EXISTS dwh.load_dates_customer_report_datamart;
CREATE TABLE IF NOT EXISTS dwh.load_dates_customer_report_datamart (
    id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    load_dttm DATE NOT NULL,
    CONSTRAINT load_dates_customer_report_datamart_pk PRIMARY KEY (id)
);
-- витрина
DROP TABLE IF EXISTS dwh.customer_report_datamart;
CREATE TABLE IF NOT EXISTS dwh.customer_report_datamart (
    id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL, -- идентификатор записи
    customer_id BIGINT NOT NULL, -- идентификатор заказчика
    customer_name VARCHAR NOT NULL, -- Ф.И.О. заказчика
    customer_address VARCHAR NOT NULL, -- адрес заказчика
    customer_birthday DATE NOT NULL, -- дата рождения заказчика
    customer_email VARCHAR NOT NULL, -- электронная почта мастера
    customer_money NUMERIC(15,2) NOT NULL, -- сумма, которую потратил заказчик
    platform_money BIGINT NOT NULL, -- сумма, которую заработала платформа от покупок заказчика за месяц (10% от суммы, которую потратил заказчик)
    count_order BIGINT NOT NULL, -- количество заказов у заказчика за месяц
    avg_price_order NUMERIC(10,2) NOT NULL, -- средняя стоимость одного заказа у заказчика за месяц
    median_time_order_completed NUMERIC(10,1), -- медианное время в днях от момента создания заказа до его завершения за месяц
    top_product_category VARCHAR NOT NULL, -- самая популярная категория товаров у этого заказчика за месяц
    top_craftsman_id BIGINT NOT NULL, -- идентификатор самого популярного мастера ручной работы у заказчика
    count_order_created BIGINT NOT NULL, -- количество созданных заказов за месяц
    count_order_in_progress BIGINT NOT NULL, -- количество заказов в процессе изготовки за месяц
    count_order_delivery BIGINT NOT NULL, -- количество заказов в доставке за месяц
    count_order_done BIGINT NOT NULL, -- количество завершённых заказов за месяц
    count_order_not_done BIGINT NOT NULL, -- количество незавершённых заказов за месяц
    report_period VARCHAR NOT NULL, -- отчётный период год и месяц
    CONSTRAINT customer_report_datamart_pk PRIMARY KEY (id)
);
