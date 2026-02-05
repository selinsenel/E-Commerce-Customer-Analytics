-- 1. Müşteri Yaşam Süresi (Lifetime) Analizi
-- Müşterilerin ilk ve son alışverişleri arasındaki süreyi (sadakat süresini) hesaplar.
SELECT
    customer_id,
    EXTRACT(DAY FROM last_date - first_date) AS lifetime_days,
    total_invoices,
    total_revenue
FROM (
    SELECT
        customer_id,
        MIN(invoice_date) AS first_date,
        MAX(invoice_date) AS last_date,
        COUNT(DISTINCT invoice_no) AS total_invoices,
        SUM(revenue) AS total_revenue
    FROM analytics.fact_sales
    GROUP BY customer_id
) t
ORDER BY total_revenue DESC;

-- 2. Yaşam Süresi Segmentasyonu
-- Müşterileri bizden alışveriş yaptıkları toplam süreye göre kategorize eder.
SELECT
    CASE
        WHEN lifetime_days <= 30 THEN 'Short-Term'
        WHEN lifetime_days <= 180 THEN 'Mid-Term'
        ELSE 'Long-Term'
    END AS lifetime_segment,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(total_revenue) AS total_revenue,
    AVG(total_revenue) AS avg_revenue_per_customer,
    AVG(total_invoices) AS avg_invoices
FROM (
    SELECT
        customer_id,
        EXTRACT(DAY FROM MAX(invoice_date) - MIN(invoice_date)) AS lifetime_days,
        COUNT(DISTINCT invoice_no) AS total_invoices,
        SUM(revenue) AS total_revenue
    FROM analytics.fact_sales
    GROUP BY customer_id
) t
GROUP BY lifetime_segment
ORDER BY total_revenue DESC;

-- 3. Güncel Durum ve Churn (Müşteri Kaybı) Hazırlığı
-- Veri setindeki en son tarihi bulur (Analiz bu tarihe göre yapılacaktır).
SELECT MAX(invoice_date) AS dataset_last_date FROM analytics.fact_sales;

-- 4. Detaylı Churn Analizi
-- Her müşterinin son alışverişinden bu yana kaç gün geçtiğini (Recency) hesaplar.
WITH customer_stats AS (
    SELECT
        customer_id,
        MAX(invoice_date) AS last_purchase_date,
        COUNT(DISTINCT invoice_no) AS total_invoices,
        SUM(revenue) AS total_revenue
    FROM analytics.fact_sales
    GROUP BY customer_id
),
churn_base AS (
    SELECT
        customer_id,
        total_invoices,
        total_revenue,
        last_purchase_date,
        DATE_PART(
            'day',
            (SELECT MAX(invoice_date) FROM analytics.fact_sales) - last_purchase_date
        ) AS days_since_last_purchase
    FROM customer_stats
)
SELECT *
FROM churn_base
ORDER BY days_since_last_purchase DESC;

-- 5. Riskli Müşteri Listesi (Actionable Insight)
-- 90 gündür gelmeyen ancak daha önce en az 5 kez alışveriş yapmış "kaybedilmek üzere olan" değerli müşterileri listeler.
SELECT
    customer_id,
    total_invoices,
    total_revenue,
    last_purchase_date,
    days_since_last_purchase
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS total_invoices,
        SUM(revenue) AS total_revenue,
        MAX(invoice_date) AS last_purchase_date,
        DATE_PART(
            'day',
            (SELECT MAX(invoice_date) FROM analytics.fact_sales) - MAX(invoice_date)
        ) AS days_since_last_purchase
    FROM analytics.fact_sales
    GROUP BY customer_id
) t
WHERE days_since_last_purchase >= 90
  AND total_invoices >= 5
ORDER BY total_revenue DESC;