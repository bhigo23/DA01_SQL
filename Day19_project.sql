create table SALES_DATASET_RFM_PRJ
(
  ordernumber VARCHAR,
  quantityordered VARCHAR,
  priceeach        VARCHAR,
  orderlinenumber  VARCHAR,
  sales            VARCHAR,
  orderdate        VARCHAR,
  status           VARCHAR,
  productline      VARCHAR,
  msrp             VARCHAR,
  productcode      VARCHAR,
  customername     VARCHAR,
  phone            VARCHAR,
  addressline1     VARCHAR,
  addressline2     VARCHAR,
  city             VARCHAR,
  state            VARCHAR,
  postalcode       VARCHAR,
  country          VARCHAR,
  territory        VARCHAR,
  contactfullname  VARCHAR,
  dealsize         VARCHAR
) 

--chuyển đổi dữ liệu
SELECT * FROM SALES_DATASET_RFM_PRJ;
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE smallint USING (trim(ordernumber)::smallint);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE smallint USING (quantityordered::smallint);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE smallint USING (trim(orderlinenumber)::smallint);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric USING (trim(sales)::numeric);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE timestamp USING (trim(orderdate)::timestamp);

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE smallint USING (trim(msrp)::smallint);

--check NULL/BLANK
SELECT * FROM sales_dataset_rfm_prj
WHERE ORDERNUMBER IS NULL
OR QUANTITYORDERED IS NULL 
OR PRICEEACH IS NULL 
OR ORDERLINENUMBER IS NULL 
OR SALES IS NULL 
OR ORDERDATE IS NULL;

--thêm cột 
CREATE TEMP TABLE sales_dataset_rfm_prj AS (
SELECT 
	*,
	UPPER(LEFT(SUBSTRING(contactfullname,1,POSITION('-' IN contactfullname)-1),1)) 
	|| SUBSTRING(contactfullname,2,POSITION('-' IN contactfullname)-2) as CONTACTFIRSTNAME ,
	UPPER(LEFT(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+1),1))
	|| SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+2) as CONTACTLASTNAME,
	CASE 
		WHEN EXTRACT(month FROM orderdate) IN (1,2,3) THEN 1
		WHEN EXTRACT(month FROM orderdate) IN (4,5,6) THEN 2
		WHEN EXTRACT(month FROM orderdate) IN (7,8,9) THEN 3
		ELSE 4
	END QTR_ID,
	EXTRACT(month FROM orderdate) AS MONTH_ID,
	EXTRACT(YEAR FROM orderdate) AS YEAR_ID
FROM sales_dataset_rfm_prj)

--tìm outlier
WITH find_outlier AS (
SELECT 
	Q1 - 1.5*IQR AS MIN,
	Q3 + 1.5*IQR AS MAX
FROM (
SELECT 
	PERCENTILE_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
	PERCENTILE_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3,
	
	PERCENTILE_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) - 
	PERCENTILE_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
FROM sales_dataset_rfm_prj) sub),
outlier AS (
SELECT * FROM sales_dataset_rfm_prj
WHERE quantityordered < (SELECT MIN FROM find_outlier)
OR quantityordered > (SELECT MAX FROM find_outlier))

--xử lí outlier
--cách 1:
UPDATE sales_dataset_rfm_prj
SET quantityordered = (SELECT AVG(quantityordered) FROM sales_dataset_rfm_prj)	
WHERE quantityordered IN (SELECT quantityordered FROM outlier)
--cách 2:
DELETE FROM sales_dataset_rfm_prj 
WHERE quantityordered IN (SELECT quantityordered FROM outlier)

--lưu thành bảng mới
CREATE VIEW SALES_DATASET_RFM_PRJ_CLEAN AS (
SELECT 
	*,
	UPPER(LEFT(SUBSTRING(contactfullname,1,POSITION('-' IN contactfullname)-1),1)) 
	|| SUBSTRING(contactfullname,2,POSITION('-' IN contactfullname)-2) as CONTACTFIRSTNAME ,
	UPPER(LEFT(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+1),1))
	|| SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+2) as CONTACTLASTNAME,
	CASE 
		WHEN EXTRACT(month FROM orderdate) IN (1,2,3) THEN 1
		WHEN EXTRACT(month FROM orderdate) IN (4,5,6) THEN 2
		WHEN EXTRACT(month FROM orderdate) IN (7,8,9) THEN 3
		ELSE 4
	END QTR_ID,
	EXTRACT(month FROM orderdate) AS MONTH_ID,
	EXTRACT(YEAR FROM orderdate) AS YEAR_ID
FROM sales_dataset_rfm_prj)
