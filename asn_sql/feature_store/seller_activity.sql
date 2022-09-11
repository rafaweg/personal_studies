-- Databricks notebook source
WITH full_table AS (
SELECT
  t1.*,
  t2.*
FROM
  silver_olist.orders t1
LEFT JOIN
  silver_olist.order_items AS t2
ON
  t1.idOrder = t2.idOrder
WHERE
  dtPurchase < '2018-01-01'
  AND dtPurchase >= add_months('2018-01-01', -6)
),

summary_table AS (
SELECT
  idSeller,
  '2018-01-01' AS dtReference,
  count(Distinct date(dtPurchase)) as qtActiveDays,
  min(datediff('2018-01-01',date(dtPurchase))) AS qtRecency,
  sum(vlPrice) AS vlRevenue
FROM
  full_table
GROUP BY
  idseller
),

top_table AS (
SELECT
  *,
  ROW_NUMBER() OVER (PARTITION BY dtReference ORDER BY vlRevenue DESC) AS vlTop
FROM
  summary_table
)

SELECT
  t1.idSeller,
  t1.dtReference,
  t1.qtRecency,
  t1.vlTop,
  CASE
    WHEN t1.vlTop <= 10 THEN 1
    ELSE 0 END AS flTop10,
  CASE
    WHEN t1.vlTop <= 100 THEN 1
    ELSE 0 END AS flTop100,
  t2.descCity,
  t2.descState
FROM
  top_table t1
LEFT JOIN
  silver_olist.sellers t2
ON
  t1.idSeller = t2.idSeller

-- COMMAND ----------


