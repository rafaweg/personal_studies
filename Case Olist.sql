-- Databricks notebook source
SELECT DISTINCT
  product_category_name
FROM
  bronze_olist.olist_products_dataset

-- COMMAND ----------

SELECT
  count(DISTINCT seller_id)
FROM
  bronze_olist.olist_sellers_dataset

-- COMMAND ----------


