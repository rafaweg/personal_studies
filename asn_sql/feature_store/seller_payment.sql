-- Databricks notebook source
WITH

full_table AS (
SELECT
  t2.*,
  t3.idSeller
FROM
  silver_olist.orders t1
LEFT JOIN
  silver_olist.order_payment t2
ON
  t1.idOrder = t2.idOrder
LEFT JOIN
  silver_olist.order_items t3
ON
  t1.idOrder = t3.idOrder
WHERE
  t1.dtPurchase < '2018-01-01'
  AND t1.dtPurchase >= add_months('2018-01-01',-6)
)

SELECT
  idSeller,
  count(DISTINCT descType) AS qtPaymentType,
  avg(nrInstallments) AS qtAvgInstallments,
  max(nrInstallments) AS qtMaxInstallments,
  min(nrInstallments) AS qtMinInstallments,
  SUM(CASE
        WHEN descType = 'boleto' THEN 1
        ELSE 0 END) / count(DISTINCT idOrder) AS pctBoleto,
  SUM(CASE
        WHEN descType = 'not_defined' THEN 1
        ELSE 0 END) / count(DISTINCT idOrder) AS pctNotDefined,
  SUM(CASE
        WHEN descType = 'credit_card' THEN 1
        ELSE 0 END) / count(DISTINCT idOrder) AS pctCreditCard,
  SUM(CASE
        WHEN descType = 'voucher' THEN 1
        ELSE 0 END) / count(DISTINCT idOrder) AS pctVoucher,
  SUM(CASE
        WHEN descType = 'debit_card' THEN 1
        ELSE 0 END) / count(DISTINCT idOrder) AS pctDebitCard,
    SUM(CASE
        WHEN descType = 'boleto' THEN vlPayment
        ELSE 0 END) / sum(vlPayment) AS pctBoletoRevenue,
  SUM(CASE
        WHEN descType = 'not_defined' THEN 1
        ELSE 0 END) / sum(vlPayment) AS pctNotDefinedRevenue,
  SUM(CASE
        WHEN descType = 'credit_card' THEN 1
        ELSE 0 END) / sum(vlPayment) AS pctCreditCardRevenue,
  SUM(CASE
        WHEN descType = 'voucher' THEN 1
        ELSE 0 END) / sum(vlPayment) AS pctVoucherRevenue,
  SUM(CASE
        WHEN descType = 'debit_card' THEN 1
        ELSE 0 END) / sum(vlPayment) AS pctDebitCardRevenue
FROM
  full_table
GROUP BY
  idSeller

-- COMMAND ----------


