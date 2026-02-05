import pandas as pd
from sqlalchemy import create_engine

# PostgreSQL bağlantısı (senin kullanıcı adın apple)
engine = create_engine(
    "postgresql+psycopg2://apple@127.0.0.1:5432/revenue_analysis"
)

# Excel dosyasını oku (2010-2011 sheet)
df = pd.read_excel(
    "data/raw/online_retail_II.xlsx",
    sheet_name="Year 2010-2011"
)

# Kolon isimlerini tabloya uydur
df = df.rename(columns={
    "InvoiceNo": "invoice_no",
    "StockCode": "stock_code",
    "Description": "description",
    "Quantity": "quantity",
    "InvoiceDate": "invoice_date",
    "Price": "unit_price",
    "Customer ID": "customer_id",
    "Country": "country"
})

print(df.head())
print("Toplam satır:", len(df))

# PostgreSQL'e yaz
df.to_sql(
    "raw_sales",
    engine,
    schema="analytics",
    if_exists="replace",
    index=False
)

print("raw_sales tablosu yüklendi")
