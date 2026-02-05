
# 📊 E-Commerce Customer Analytics & Strategic Segmentation

## 📝 Project Overview
This project delivers a comprehensive end-to-end data analysis solution for an e-commerce dataset. By leveraging **SQL** for complex data transformations and **Tableau** for high-level business intelligence, I transformed raw transactional data into actionable strategic insights.

## 🛠️ Technical Stack
* **Database:** PostgreSQL (Data cleaning, CTEs, Window Functions, View creation)
* **Visualization:** Tableau Desktop (Interactive Dashboards)
* **Analysis:** RFM Modeling, Trend Analysis, Retention & Churn Analysis

## 🖼️ Executive Dashboard
![Executive Dashboard](screenshots/image_2e075d.png)
> [👉 View Interactive Dashboard on Tableau Public](https://public.tableau.com/views/customeranalysis_17703242857770/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## 🔍 Visual Analysis & Business Insights

### 1. Monthly Transaction Volume and Sales Trend
![Monthly Trends](screenshots/Monthly Transaction Volume and Sales Trend)
* **What it shows:** An area chart depicting the fluctuation of transaction volume over time.
* **Insight:** The data reveals a massive **November peak** (2,658 invoices), likely driven by seasonal promotions or Black Friday events. This indicates a high seasonal dependency for the business.

### 2. Customer Segmentation Breakdown (Count)
![Segmentation](screenshots/Customer Segmentation)
* **What it shows:** A bar chart classifying the customer base into three strategic groups: Loyal, Regular, and High-Value.
* **Insight:** While 'Regular Customers' make up the vast majority by count, the 'Loyal' group is the most consistent. I used a **Logarithmic Scale** here to ensure smaller but critical segments are clearly visible.

### 3. Segment-Based Total Revenue Distribution
![Revenue Share](screenshots/Segment-Based Total Revenue Distribution)
* **What it shows:** The total revenue contribution of each customer segment.
* **Insight:** Even though 'Loyal' and 'High-Value' customers are fewer in number, they contribute disproportionately to the total revenue (over 2M and 200K respectively). This highlights the importance of retention over acquisition.

### 4. Customer Value Matrix (Volume vs. Frequency)
![Scatter Plot](screenshots/Customer Value Matrix (Volume vs. Frequency)
* **What it shows:** A scatter plot mapping every customer based on their number of invoices versus their average revenue per invoice.
* **Insight:** We can clearly identify **VIP outliers** (blue circles) at the top of the Y-axis. These are customers who shop infrequently but have an extremely high basket value ($70K+), requiring a separate account management strategy.

---

## 📂 Project Structure
* `sql-queries/`: Contains all SQL scripts for cleaning and analysis.
* `customer analysis.twbx`: The packaged Tableau workbook for deep-dive analysis.
* `screenshots/`: Visual assets used in this documentation.<img width="1082" height="2240" alt="image" src="https://github.com/user-attachments/assets/a25d28bd-56e7-4d18-80c4-97e211629d4b" />


