-- Top trending last week (last monday => last sunday)
CREATE MATERIALIZED VIEW top_trending_lastweek AS
SELECT
    pd.id,
    pd.name AS product_name,
    c.name AS category_name,
    sum(od.quantity) AS total_sales,
    sum(od.quantity * od.price_product_order) AS amount_money
FROM
    (
        (
            (
                (
                    orders o
                    JOIN order_details od ON ((o.id = od.order_id))
                )
                JOIN payment pm ON ((pm.order_id = od.order_id))
            )
            JOIN product pd ON ((pd.id = od.product_id))
        )
        JOIN category c ON ((c.id = pd.category_id))
    )
WHERE
    pm.updated_at BETWEEN DATE_TRUNC('week', NOW()) - interval '7 day'
    AND DATE_TRUNC('week', NOW())
GROUP BY
    pd.name,
    c.name,
    pd.id
ORDER BY
    sum(od.quantity) DESC WITH NO DATA;

REFRESH MATERIALIZED VIEW top_trending_lastweek;

-- WITH NO DATA When call refresh => can call select
SELECT
    *
FROM
    top_trending_lastweek;

-----------------------------------------
-- Top trending last week to now
CREATE MATERIALIZED VIEW top_trending_lastweek_to_now AS
SELECT
    to_now.id,
    to_now.product_name,
    to_now.category_name,
    sum(to_now.total_sales) AS total_sales,
    sum(to_now.amount_money) AS amount_money
FROM
    (
        SELECT
            *
        FROM
            top_trending_lastweek
        UNION
        ALL
        SELECT
            *
        FROM
            top_trending_current_week
    ) to_now
GROUP BY
    to_now.product_name,
    to_now.category_name,
    to_now.id
ORDER BY
    to_now.id ASC WITH NO DATA;

REFRESH MATERIALIZED VIEW top_trending_lastweek_to_now;

SELECT
    *
FROM
    top_trending_lastweek_to_now;

------------------------------------------------
-- Top trending this week (this monday => now)
CREATE MATERIALIZED VIEW top_trending_current_week AS
SELECT
    pd.id,
    pd.name AS product_name,
    c.name AS category_name,
    sum(od.quantity) AS total_sales,
    sum(od.quantity * od.price_product_order) AS amount_money
FROM
    (
        (
            (
                (
                    orders o
                    JOIN order_details od ON ((o.id = od.order_id))
                )
                JOIN payment pm ON ((pm.order_id = od.order_id))
            )
            JOIN product pd ON ((pd.id = od.product_id))
        )
        JOIN category c ON ((c.id = pd.category_id))
    )
WHERE
    pm.updated_at >= DATE_TRUNC('week', now())
GROUP BY
    pd.name,
    c.name,
    pd.id
ORDER BY
    sum(od.quantity) DESC WITH NO DATA;

REFRESH MATERIALIZED VIEW top_trending_current_week;

-- WITH NO DATA When call refresh => can call select
SELECT
    *
FROM
    top_trending_current_week;

-----------------------------------------
-- Top trending last week (1st day last month => 1st day this month)
CREATE MATERIALIZED VIEW top_trending_lastmonth AS
SELECT
    pd.name AS product_name,
    c.name AS category_name,
    sum(od.quantity) AS total_sales,
    sum(od.quantity * od.price_product_order) AS amount_money
FROM
    (
        (
            (
                (
                    orders o
                    JOIN order_details od ON ((o.id = od.order_id))
                )
                JOIN payment pm ON ((pm.order_id = od.order_id))
            )
            JOIN product pd ON ((pd.id = od.product_id))
        )
        JOIN category c ON ((c.id = pd.category_id))
    )
WHERE
    pm.updated_at BETWEEN DATE_TRUNC('month', NOW()) - interval '1'
    AND DATE_TRUNC('month', NOW())
GROUP BY
    pd.name,
    c.name
ORDER BY
    sum(od.quantity) DESC WITH NO DATA;

REFRESH MATERIALIZED VIEW top_trending_lastmonth;

-- WITH NO DATA When call refresh => can call select
SELECT
    *
FROM
    top_trending_lastmonth;

-----------------------------
-- Top trending last week (1st day this month => now)
CREATE MATERIALIZED VIEW top_trending_current_month AS
SELECT
    pd.name AS product_name,
    c.name AS category_name,
    sum(od.quantity) AS total_sales,
    sum(od.quantity * od.price_product_order) AS amount_money
FROM
    (
        (
            (
                (
                    orders o
                    JOIN order_details od ON ((o.id = od.order_id))
                )
                JOIN payment pm ON ((pm.order_id = od.order_id))
            )
            JOIN product pd ON ((pd.id = od.product_id))
        )
        JOIN category c ON ((c.id = pd.category_id))
    )
WHERE
    pm.updated_at >= DATE_TRUNC('month', NOW())
GROUP BY
    pd.name,
    c.name
ORDER BY
    sum(od.quantity) DESC WITH NO DATA;

REFRESH MATERIALIZED VIEW top_trending_current_month;

-- WITH NO DATA When call refresh => can call select
SELECT
    *
FROM
    top_trending_current_month;

-----------------------------------------------
-- Top trending last week (1st day last year => 1st day this year)
CREATE MATERIALIZED VIEW top_trending_lastyear AS
SELECT
    pd.name AS product_name,
    c.name AS category_name,
    sum(od.quantity) AS total_sales,
    sum(od.quantity * od.price_product_order) AS amount_money
FROM
    (
        (
            (
                (
                    orders o
                    JOIN order_details od ON ((o.id = od.order_id))
                )
                JOIN payment pm ON ((pm.order_id = od.order_id))
            )
            JOIN product pd ON ((pd.id = od.product_id))
        )
        JOIN category c ON ((c.id = pd.category_id))
    )
WHERE
    pm.updated_at BETWEEN DATE_TRUNC('year', NOW()) - interval '1'
    AND DATE_TRUNC('year', NOW())
GROUP BY
    pd.name,
    c.name
ORDER BY
    sum(od.quantity) DESC WITH NO DATA;

REFRESH MATERIALIZED VIEW top_trending_lastyear;

-- WITH NO DATA When call refresh => can call select
SELECT
    *
FROM
    top_trending_lastyear;