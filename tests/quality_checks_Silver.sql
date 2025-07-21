/*
=====================================================================================
Quality Checks
=====================================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'Silver' schemas. It includes checks for:
    - NULLS or dulicate primary keys.
    - Unwated spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consitency between related fields.

Usage Notes:
    - Run these checks after data loading silver layer.
    - Investigate and resolve disrepancies found during the checks.
=====================================================================================
*/

-- ==================================================================================
-- Checking 'Silver.crm_cust_info'
-- ==================================================================================
-- Check For NULLS or Duplicate in Primary Key
-- Expectation: No Results
SELECT 
   cst_id,
COUNT (*)
FROM Silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL;

-- Check For Unwated Spaces
-- Expectation: No Results
SELECT 
   cst_key
FROM Silver.crm_cust_info
WHERE cst_key != TRIM (cst_key);
  
-- Data Standardization & Consistency
SELECT DISTINCT 
   cst_marital_status
FROM Silver.crm_cust_info;
SELECT DISTINCT 
   cst_gndr
FROM Silver.crm_cust_info;

-- ==================================================================================
-- Checking 'Silver.crm_prd_info'
-- ==================================================================================
-- Check For NULLS or Duplicate in Primary Key
-- Expectation: No Results
SELECT 
   prd_id,
COUNT (*)
FROM Silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 OR prd_id IS NULL;

-- Check For Unwated Spaces
-- Expectation: No Results
SELECT 
   prd_nm
FROM Silver.crm_prd_info
WHERE prd_nm != TRIM (prd_nm);

-- Data Standardization & Consistency
SELECT DISTINCT 
   prd_line
FROM Silver.crm_prd_info;

-- Check for NULLS or Negative Values in Cost
-- Expectation: No Results
SELECT 
   prd_cost
FROM Silver.crm_prd_info
WHERE prd_cost < 0 
   OR prd_cost IS NULL;

-- ==================================================================================
-- Checking 'Silver.crm_sales_details'
-- ==================================================================================
-- Check For Invalid Data Orders
SELECT
    NULLIF (sls_order_dt,0) sls_order_dt
FROM Silver.crm_sales_details
WHERE sls_order_dt <= 0
   OR LEN (sls_order_dt)  !=8
   OR sls_order_dt > 20500101 
   OR sls_order_dt < 19000101;

-- Check For Invalid Data Orders (Orders Date > Shipping/Due Date)
-- Expectation: No Results
SELECT
  *
FROM Silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_ship_dt ? sls_due_dt;

-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values Must Not be NULL, Zero, or Negative
-- Expetation: No Results
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM Silver.crm_sales_details
WHERE sls_sales != sls_price*sls_quantity
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <=0 
   OR sls_quantity <=0  
   OR sls_price <=0 
ORDER BY sls_sales, sls_quantity, sls_price;

-- ==================================================================================
-- Checking 'Silver.erp_cust_az12'
-- ==================================================================================
-- Identify Out-of Range Dates
-- Expectation: Birthdates Between 1924-01-01 and Today
SELECT DISTINCT 
    bdate
FROM Silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT 
    gen
FROM Silver.erp_cust_az12;

-- ==================================================================================
-- Checking 'Silver.erp_loc_a101'
-- ==================================================================================
-- Data Standardization & Consistency
SELECT DISTINCT 
    cntry
FROM Silver.erp_loc_a101
ORDER BY cntry;

-- ==================================================================================
-- Checking 'Silver.erp_px_cat_g1v2'
-- ==================================================================================
-- Check For Unwated Spaces
-- Expectation: No Results
SELECT 
  *
FROM Silver.erp_px_cat_g1v2
WHERE cat != TRIM (cat)
   OR subcat != TRIM (subcat)
   OR maintence != TRIM (maintence);

-- Data Standardization & Consistency
SELECT DISTINCT 
    maintence
FROM Silver.erp_px_cat_g1v2;
