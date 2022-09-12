WITH
full_table AS (
SELECT
  t2.idSeller,
  t1.*,
  t3.*
FROM
  silver_olist.orders t1
LEFT JOIN
  silver_olist.order_items t2
ON
  t1.idOrder = t2.idOrder
LEFT JOIN
  silver_olist.products t3
ON
  t2.idProduct = t3.idProduct
WHERE
  t1.dtPurchase < '{date}'
  AND t1.dtPurchase >= add_months('{date}',-6)
),

tb_summary AS (
SELECT
  idSeller,
  avg(vlWeightGramas) AS vlAvgWeight,
  COALESCE(avg(CASE
                WHEN datediff('{date}',dtPurchase) < 30 THEN vlWeightGramas
                ELSE 0 END), 0) AS vlAvgWeight1M,
  COALESCE(avg(CASE
                WHEN datediff('{date}',dtPurchase) < 90 THEN vlWeightGramas
                ELSE 0 END), 0) AS vlAvgWeight3M,
  avg(nrNameLength) AS vlAvgNameLength,
  COALESCE(avg(CASE
                WHEN datediff('{date}',dtPurchase) < 30 THEN nrNameLength
                ELSE 0 END), 0) AS vlAvgNameLengtht1M,
  COALESCE(avg(CASE
                WHEN datediff('{date}',dtPurchase) < 90 THEN nrNameLength
                ELSE 0 END), 0) AS vlAvgNameLength3M,
  avg(nrPhotos) AS vlAvgPhotos,
  COALESCE(avg(CASE
                WHEN datediff('{date}',dtPurchase) < 30 THEN nrPhotos
                ELSE 0 END), 0) AS vlAvgPhotos1M,
  COALESCE(avg(CASE
                WHEN datediff('{date}',dtPurchase) < 90 THEN nrPhotos
                ELSE 0 END), 0) AS vlAvgPhotos3M,
  avg(vlLengthCm * vlHeightCm * vlWidthCm) AS vlAvgProductVolume,
  COALESCE(avg(CASE
                WHEN datediff('{date}',dtPurchase) < 30 THEN (vlLengthCm * vlHeightCm * vlWidthCm)
                ELSE 0 END), 0) AS vlAvgProductVolume1M,
  COALESCE(avg(CASE
                WHEN datediff('{date}',dtPurchase) < 90 THEN (vlLengthCm * vlHeightCm * vlWidthCm)
                ELSE 0 END), 0) AS vlAvgProductVolume3M,
  count(DISTINCT descCategoryName) AS qtCategoryType,
  count(DISTINCT CASE
                  WHEN datediff('{date}',dtPurchase) < 30 THEN descCategoryName END) AS qtCategoryType1M,
  count(DISTINCT CASE
                  WHEN datediff('{date}',dtPurchase) < 90 THEN descCategoryName END) AS qtCategoryType3M,
  count(DISTINCT idProduct) AS qtProducts,
  count(DISTINCT CASE
                  WHEN datediff('{date}',dtPurchase) < 30 THEN idProduct END) AS qtProducts1M,
  count(DISTINCT CASE
                  WHEN datediff('{date}',dtPurchase) < 90 THEN idProduct END) AS qtProducts3M
FROM
  full_table
GROUP BY
  idSeller
),


tb_seller_category AS (
SELECT
  idSeller,
  descCategoryName,
  count(*) AS qtCategory
FROM
  full_table
GROUP BY
  idSeller,
  descCategoryName
),

tb_best_category AS (
SELECT
  *,
  ROW_NUMBER() OVER (PARTITION BY idSeller ORDER BY qtCategory DESC) AS rankCategory
FROM
  tb_seller_category
QUALIFY
  rankCategory = 1
)

SELECT
  t1.*,
  t2.descCategoryName
FROM
  tb_summary t1
LEFT JOIN
  tb_best_category t2
ON
  t1.idSeller = t2.idSeller
  

