/*
============================================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
============================================================================================================
Script Purpose:
    This stored procedure loads data into the 'Bronze' schema from external CSV files. it performs
    the following actions:
    - Truncate the Bronze tables before loading data.
    - Users the 'BULK INSERT' command to load data from CSV files to Bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Bronze.load_Bronze
============================================================================================================
*/
ALTER PROCEDURE [Bronze].[load_Bronze] AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE ();
		PRINT '=============================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=============================================';

		PRINT '---------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '---------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_cust_info';
		TRUNCATE TABLE Bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: Bronze.crm_cust_info';
		BULK INSERT Bronze.crm_cust_info
		FROM 'D:\Dokkaebi\Excel\custo_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_prd_info';
		TRUNCATE TABLE Bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: Bronze.crm_prd_info';
		BULK INSERT Bronze.crm_prd_info
		FROM 'D:\Dokkaebi\Excel\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_sales_details';
		TRUNCATE TABLE Bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: Bronze.crm_sales_details';
		BULK INSERT Bronze.crm_sales_details
		FROM 'D:\Dokkaebi\Excel\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------';

		PRINT '---------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '---------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_cust_az12';
		TRUNCATE TABLE Bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: Bronze.erp_cust_az12';
		BULK INSERT Bronze.erp_cust_az12
		FROM 'D:\Dokkaebi\Excel\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_loc_a101';
		TRUNCATE TABLE Bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: Bronze.erp_loc_a101';
		BULK INSERT Bronze.erp_loc_a101
		FROM 'D:\Dokkaebi\Excel\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------';
	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
	
		PRINT '>> Inserting Data Into: Bronze.erp_px_cat_g1v2';
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'D:\Dokkaebi\Excel\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------';

		SET @batch_end_time = GETDATE ();
		PRINT '============================================='
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '		- Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '============================================='

	END TRY
	BEGIN CATCH
		PRINT '============================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '================================================'
	END CATCH
END
