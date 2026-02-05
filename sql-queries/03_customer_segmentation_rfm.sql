-- 1. Müşteri Segmentasyonu (RFM Mantığı)
-- Müşterileri sipariş sıklığı ve harcama miktarına göre 3 ana gruba ayırır.
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS invoices,
    SUM(revenue) AS total_revenue,
    SUM(revenue) / COUNT(DISTINCT invoice_no) AS revenue_per_invoice,
    CASE
        WHEN COUNT(DISTINCT invoice_no) <= 3 
             AND SUM(revenue) / COUNT(DISTINCT invoice_no) > 20000 
            THEN 'High-Value One-Off'
        WHEN COUNT(DISTINCT invoice_no) >= 30 
            THEN 'Loyal Customer'
        ELSE 'Regular Customer'
    END AS customer_segment
FROM analytics.fact_sales
GROUP BY customer_id
ORDER BY total_revenue DESC;

-- 2. Segment Bazlı Özet İstatistikler
-- Her segmentte kaç müşteri olduğu ve toplam ne kadar ciro getirdiklerini analiz eder.
SELECT
    customer_segment,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT invoice_no) AS invoices,
    SUM(revenue) AS total_revenue,
    SUM(revenue) / COUNT(DISTINCT customer_id) AS revenue_per_customer
FROM analytics.fact_sales
GROUP BY customer_segment
ORDER BY total_revenue DESC;

-- 3. Kalıcı Segment Görünümü (View) Oluşturma
-- Tableau ve diğer raporlar için segmentasyon mantığını bir View içine kaydeder.
CREATE OR REPLACE VIEW analytics.customer_segments AS
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS invoices,
    SUM(revenue) AS total_revenue,
    SUM(revenue) / COUNT(DISTINCT invoice_no) AS revenue_per_invoice,
    CASE
        WHEN COUNT(DISTINCT invoice_no) <= 3 
             AND SUM(revenue) / COUNT(DISTINCT invoice_no) > 20000 
            THEN 'High-Value One-Off'
        WHEN COUNT(DISTINCT invoice_no) >= 30 
            THEN 'Loyal Customer'
        ELSE 'Regular Customer'
    END AS customer_segment
FROM analytics.fact_sales
GROUP BY customer_id;

-- 4. Gelir Payı Analizi (Revenue Share)
-- Hangi segmentin toplam ciro içindeki yüzde payını hesaplar.
WITH customer_kpis AS (
  SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS invoices,
    SUM(revenue) AS total_revenue,
    SUM(revenue) / COUNT(DISTINCT invoice_no) AS revenue_per_invoice
  FROM analytics.fact_sales
  GROUP BY customer_id
),
segmented AS (
  SELECT
    customer_id,
    total_revenue,
    CASE
      WHEN invoices >= 50 THEN 'Loyal Customer'
      WHEN invoices = 1 AND revenue_per_invoice >= 50000 THEN 'High-Value One-Off'
      ELSE 'Regular Customer'
    END AS customer_segment
  FROM customer_kpis
),
tot AS (
  SELECT SUM(total_revenue) AS grand_total FROM segmented
)
SELECT
  s.customer_segment,
  SUM(s.total_revenue) AS total_revenue,
  (SUM(s.total_revenue) / t.grand_total) * 100 AS revenue_share_pct
FROM segmented s
CROSS JOIN tot t
GROUP BY s.customer_segment, t.grand_total
ORDER BY total_revenue DESC;