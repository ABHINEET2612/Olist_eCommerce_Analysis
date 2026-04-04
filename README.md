# Olist_e-Commerce_Analysis
End-to-End data analysis project using Python, MySQL,  and Power BI

# 🛒 Olist E-Commerce Data Analysis

## 📊 Project Overview
This project presents an end-to-end analysis of the Brazilian Olist e-commerce dataset to uncover actionable insights related to sales performance, customer behavior, delivery efficiency, and regional trends.

The analysis is performed using **Python for data processing**, **SQL for querying**, and **Power BI for visualization**, simulating a real-world business intelligence workflow.

---
## ❓ Problem Statement
The objective of this project is to analyze Olist's e-commerce data to identify key drivers of revenue, customer satisfaction, and operational inefficiencies.

## 🎯 Objectives
- Analyze revenue growth and seasonal trends  
- Identify top-performing product categories  
- Understand customer payment behavior  
- Evaluate delivery performance and its impact on satisfaction  
- Identify geographic opportunities for expansion  

---
## 📌 Key Metrics Snapshot
- Total Orders: 99,000
- Revenue: R$ 16.01 Million
- Late Delivery Rate: 7.93%
- Avg Delay: 10.57 days
- 5-Star Reviews: 57%
---
## 🛠️ Tools & Technologies
- **Python** (Pandas, NumPy, Matplotlib, Seaborn)  
- **SQL** (MySQL)  
- **Power BI**  
---
## 🧾 SQL Analysis

SQL was used to transform raw data into actionable insights across multiple dimensions of the business.

- **Data Preparation:** Created relational tables and loaded multiple datasets with proper formatting and validation  
- **Performance Optimization:** Used indexing to improve query efficiency  
- **Revenue Analysis:** Monthly trends, MoM growth (CTE + LAG), and running totals (window functions)  
- **Delivery Performance:** Late delivery rate and its impact on customer reviews  
- **Customer Insights:** Identified high-value customers using subqueries  
- **Product & Category Analysis:** Top-performing categories and AOV vs volume behavior  
- **Geographic Insights:** State-wise revenue and identification of logistics bottlenecks  
- **Seller Analysis:** Ranked sellers based on revenue contribution  

**Key SQL Concepts Used:**  
CTEs, Window Functions (LAG, SUM OVER), Subqueries, Joins, Aggregations  

📄 Full SQL workflow available in: `sql/Olist_Analysis.sql`.
---

## 📂 Project Structure
- notebooks/ → Python data analysis
- sql/ → SQL queries
- assets/ → Dashboard screenshots
- data/ → Dataset reference


---

## 📊 Dashboard Preview

### 📌 Page 1 – Sales & Revenue Overview
![Dashboard 1](assets/Dashboard_Page-1.png)

---

### 📌 Page 2 – Geographic Analysis
![Dashboard 2](assets/Dashboard_Page-2.png)

---

### 📌 Page 3 – Recommendations
![Dashboard 3](assets/Dashboard_Page-3.png)

---
## 📊 Power BI Dashboard File

Due to file size limitations, the Power BI dashboard file is hosted externally.

🔗 **Download Dashboard (.pbix):**  
[Click here to access the Dashboard](https://drive.google.com/file/d/1BAU8_466LinyOzzB3wHg-VFq1AFbZCXJ/view?usp=sharing)

> Note: The file may take a few seconds to download due to its size.
---
## 🔍 Key Insights

### 📈 Sales & Revenue Trends
- Revenue scaled rapidly from late 2016 to mid-2018, consistently exceeding **R$1M/month**, indicating strong platform growth.
- A major spike in **November 2017 (+53% MoM)** highlights the strong impact of **Black Friday**.
- **Bed, Bath & Table** and **Health & Beauty** dominate both revenue and order volume.
- **Computers & Accessories** → high revenue with fewer orders (**high AOV**).
- **Sports & Leisure** → high order volume but lower revenue (**low-value, high-frequency purchases**).

---

### 💳 Payment Behavior
- **~74% of transactions use credit cards**, driven by installment-based purchasing.
- **~19% use boleto**, representing a significant **underbanked customer segment**.
- Nearly **1 in 5 customers rely on non-card payments**, requiring targeted strategies.

---

### 🚚 Delivery Performance
- **7.83% of orders are delivered late** (~7,500+ orders).
- Late deliveries are delayed by an average of **10.57 days**.
- Strong impact on satisfaction:
  - Late deliveries → **2.27 avg rating**
  - On-time deliveries → **4.29 avg rating**
- Delivery delays are the **primary driver of negative reviews**.

---

### ⭐ Customer Satisfaction
- Review distribution is **J-shaped**:
  - **57% of customers give 5-star ratings**
  - **1-star reviews are the second most common**
- Indicates a **polarized customer experience** driven by delivery and product issues.

---

### ⚠️ Product Quality Risks
- **Security & Services** is the lowest-rated category.
- **Bed, Bath & Table** appears in both:
  - Top revenue categories  
  - Worst-rated categories  
- Indicates **high churn risk at scale**.

---

### 🌍 Geographic Insights
- **São Paulo (SP)**:
  - ~37% of total revenue  
  - ~49% of total customers  
- **RJ and MG** follow as secondary markets.
- Northern states (**RR, AP, AM**) have:
  - Extremely high delivery times (**26–28 days**)  
  - Very low revenue contribution  
- Suggests **logistics constraints + untapped growth opportunity**.

---
## 📈 Business Impact
This analysis helps:
- Improve customer satisfaction by reducing delivery delays
- Increase revenue through seasonal demand optimization
- Identify high-risk categories affecting customer retention
- Highlight untapped geographic markets for expansion
---
## 💡 Business Recommendations

1. **Leverage Seasonal Demand**
   - November spike (+53%) shows strong seasonal potential.
   - Prepare inventory, logistics, and campaigns **30 days in advance**.

2. **Fix Delivery Delays (Critical Priority)**
   - Late deliveries significantly reduce customer satisfaction.
   - Improve delivery estimates and expand logistics partnerships.

3. **Improve Product Quality Control**
   - Focus on **Bed, Bath & Table** category.
   - High revenue + poor reviews = high churn risk.

4. **Target Boleto Users**
   - ~19% customers rely on boleto.
   - Introduce **boleto-specific offers and flexible payment options**.

5. **Expand in Underserved Regions**
   - Northern states show low revenue but high potential.
   - Increase **local seller onboarding** to improve delivery speed and coverage.

---

## 📁 Dataset Information
The dataset used in this project is sourced from Kaggle and consists of multiple CSV files representing different aspects of an e-commerce platform.

👉 Refer to: `data/dataset_source.md`

---

## 👤 Author
**Abhineet Gaur**
