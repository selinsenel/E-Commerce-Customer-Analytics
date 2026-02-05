-- 1. Aylık Satış ve Gelir Trendi
-- Bu sorgu, işletmenin zaman içindeki büyümesini ve mevsimselliği analiz eder.
SELECT
  DATE_TRUNC('month', invoice_date) AS month,
  SUM(revenue)                      AS revenue,
  COUNT(DISTINCT invoice_no)        AS invoices,
  COUNT(DISTINCT customer_id)       AS customers
FROM analytics.fact_sales
GROUP BY 1
ORDER BY 1;

-- 2. Ülke Bazlı Performans Analizi (Top 10)
-- En çok gelir getiren ilk 10 ülkeyi listeler.
SELECT
  country,
  ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
  COUNT(DISTINCT invoice_no) AS invoices,
  COUNT(DISTINCT customer_id) AS customers
FROM analytics.fact_sales
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- 3. Ülke Bazlı Müşteri Başına Ortalama Gelir
-- En az 10 müşterisi olan ülkelerde, müşteri başına düşen harcama miktarını analiz eder.
SELECT
  country,
  ROUND(SUM(revenue)::numeric / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM analytics.fact_sales
GROUP BY country
HAVING COUNT(DISTINCT customer_id) >= 10
ORDER BY revenue_per_customer DESC;

-- 4. En Çok Harcama Yapan İlk 10 Müşteri
SELECT
    customer_id,
    SUM(revenue) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS invoices
FROM analytics.fact_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 5. Yüksek Hacimli İşlemlerin Analizi
-- Toplam harcaması 50.000 birimden fazla olan müşterilerin sepet ortalamasını hesaplar.
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS invoices,
    SUM(revenue) AS total_revenue,
    SUM(revenue) / COUNT(DISTINCT invoice_no) AS revenue_per_invoice
FROM analytics.fact_sales
GROUP BY customer_id
HAVING SUM(revenue) > 50000
ORDER BY revenue_per_invoice DESC;