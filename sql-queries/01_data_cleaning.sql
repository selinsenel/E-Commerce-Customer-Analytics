-- 1. Veriyi Keşfetme ve Genel Kontrol
SELECT COUNT(*) FROM analytics.raw_sales;

SELECT
    COUNT(*)              AS total_rows,
    COUNT(DISTINCT invoice_no) AS total_invoices,
    COUNT(DISTINCT customer_id) AS total_customers,
    MIN(invoice_date)     AS first_date,
    MAX(invoice_date)     AS last_date
FROM analytics.raw_sales;

-- 2. Kolon İsimlerini Standartlaştırma
ALTER TABLE analytics.raw_sales
RENAME COLUMN "Invoice" TO invoice_no;

-- 3. Hatalı ve Eksik Verileri Tespit Etme (Kalite Kontrol)
-- İptal edilen işlemler (Negatif miktarlar)
SELECT COUNT(*)
FROM analytics.raw_sales
WHERE quantity < 0;

-- Müşteri ID'si olmayan kayıtlar
SELECT COUNT(*)
FROM analytics.raw_sales
WHERE customer_id IS NULL;

-- Temiz veri seti büyüklüğünü kontrol etme
SELECT COUNT(*)
FROM analytics.raw_sales
WHERE quantity > 0
  AND customer_id IS NOT NULL;

-- 4. ANALİZ İÇİN TEMİZLENMİŞ ANA TABLOYU (FACT TABLE) OLUŞTURMA
-- Bu tablo analizlerin ve Tableau görselleştirmelerinin temelini oluşturur.
CREATE TABLE analytics.fact_sales AS
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    quantity * unit_price AS revenue, -- Satır bazlı ciro hesaplama
    invoice_date,
    customer_id,
    country
FROM analytics.raw_sales
WHERE quantity > 0
  AND customer_id IS NOT NULL;

-- 5. Oluşturulan Tablonun Doğrulanması
SELECT COUNT(*) FROM analytics.fact_sales; -- 397925 sonucu bekleniyor

SELECT
    COUNT(*)                     AS total_rows,
    COUNT(DISTINCT invoice_no)      AS total_invoices,
    COUNT(DISTINCT customer_id)  AS total_customers,
    SUM(quantity)                AS total_units_sold,
    SUM(quantity * unit_price)   AS total_revenue
FROM analytics.fact_sales;