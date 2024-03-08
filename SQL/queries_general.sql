############################
### First visualization ####
############################

USE marketing;

SELECT *
FROM customers;

SELECT *
FROM amount;

SELECT *
FROM purchases;

SELECT *
FROM campaigns;

############################
### ADDING PRIMARY KEYS ####
############################

ALTER TABLE amount
ADD CONSTRAINT id PRIMARY KEY (id);

ALTER TABLE campaigns
ADD CONSTRAINT id PRIMARY KEY (id);

ALTER TABLE customers
ADD CONSTRAINT id PRIMARY KEY (id);

ALTER TABLE purchases
ADD CONSTRAINT id PRIMARY KEY (id);


############################
### CUSTOMERS  #############
############################

-- AVERAGE INCOME PER EDUCATION LEVEL
SELECT education, 
       COUNT(id) AS n_of_clients, 
       ROUND(AVG(2024 - year_birth),0) AS average_age, 
       ROUND(AVG(income),1) AS average_income, 
       ROUND(AVG(kidhome),2) AS average_kids_at_home, 
       ROUND(AVG(teenhome),2) AS average_teens_at_home
FROM customers
GROUP BY education
ORDER BY n_of_clients DESC;

-- AVERAGE INCOME PER MARITAL STATUS
SELECT marital_status, 
	COUNT(id) AS n_of_clients, 
    ROUND(AVG(2024 - year_birth),0) AS average_age, 
    ROUND(AVG(income),1) AS average_income, 
    ROUND(AVG(kidhome),2) AS average_kids_at_home, 
    ROUND(AVG(teenhome),2) AS teens_at_home
FROM customers
WHERE marital_status <> "Absurd" AND marital_status <> "YOLO"
GROUP BY marital_status
ORDER BY n_of_clients DESC;


############################
### AMOUNT  ################
############################

-- SPENT AMOUNT
SELECT SUM(mntwines) AS total_wine,
       SUM(mntfruits) AS total_fruit,
       SUM(mntmeatproducts) AS total_meat,
       SUM(mntfishproducts) AS total_fish,
       SUM(mntsweetproducts) AS total_sweet,
       SUM(mntgoldprods) AS total_gold,
       SUM(mntwines + mntfruits + mntmeatproducts + mntfishproducts + mntsweetproducts + mntgoldprods) AS total_all_products 
FROM amount;

############################
### PURCHASES  #############
############################

-- PURCHASE WAY
SELECT SUM(numwebpurchases) AS web_purchases,
       SUM(numcatalogpurchases) AS catalog_purchases,
       SUM(numstorepurchases) AS store_purchases,
       SUM(numwebpurchases + numcatalogpurchases + numstorepurchases) AS total_purchases
FROM purchases;

-- DEAL PURCHASES
SELECT SUM(numdealspurchases) AS n_of_deals,
	   SUM(numwebpurchases + numcatalogpurchases + numstorepurchases) AS total_purchases,
       ROUND(SUM(numdealspurchases) / SUM(numwebpurchases + numcatalogpurchases + numstorepurchases) * 100, 2) AS deals_vs_purchases
FROM purchases;

############################
### CAMPAIGNS  #############
############################

SELECT SUM(acceptedcmp1) AS total_cmp1,
       ROUND(SUM(acceptedcmp1) / COUNT(id) *100, 2) AS cmp1_percent,
       SUM(acceptedcmp2) AS total_cmp2,
       ROUND(SUM(acceptedcmp2) / COUNT(id) *100, 2) AS cmp2_percent,
       SUM(acceptedcmp3) AS total_cmp3,
       ROUND(SUM(acceptedcmp3) / COUNT(id) *100, 2) AS cmp3_percent,
       SUM(acceptedcmp4) AS total_cmp4,
       ROUND(SUM(acceptedcmp4) / COUNT(id) *100, 2) AS cmp4_percent,
       SUM(acceptedcmp5) AS total_cmp5,
       ROUND(SUM(acceptedcmp5) / COUNT(id) *100, 2) AS cmp5_percent,
       SUM(acceptedcmp1 + acceptedcmp2 + acceptedcmp3 + acceptedcmp4 + acceptedcmp5) AS total_all_cmps
FROM campaigns;


############################
### CUST / AMOUNT / PURC ###
############################

-- AMOUNT SPENT AND PURCHASES PER EDUCATION
SELECT cus.education,
       COUNT(cus.id) AS n_of_clients,
	   SUM(amo.mntwines) AS total_wine,
       SUM(amo.mntfruits) AS total_fruit,
       SUM(amo.mntmeatproducts) AS total_meat,
       SUM(amo.mntfishproducts) AS total_fish,
       SUM(amo.mntsweetproducts) AS total_sweet,
       SUM(amo.mntgoldprods) AS total_gold,
       SUM(amo.mntwines + amo.mntfruits + amo.mntmeatproducts + amo.mntfishproducts + amo.mntsweetproducts + amo.mntgoldprods) AS total_all_products,
       SUM(pur.numwebpurchases) AS web_purchases,
       SUM(pur.numcatalogpurchases) AS catalog_purchases,
       SUM(pur.numstorepurchases) AS store_purchases,
       SUM(pur.numwebpurchases + pur.numcatalogpurchases + pur.numstorepurchases) AS total_purchases
FROM customers AS cus
JOIN amount AS amo
ON cus.id = amo.id
JOIN purchases AS pur
ON amo.id = pur.id
GROUP BY cus.education
ORDER BY n_of_clients DESC;

-- AMOUNT SPENT AND PURCHASES PER MARITAL STATUS
SELECT cus.marital_status,
       COUNT(cus.id) AS n_of_clients,
	   SUM(amo.mntwines) AS total_wine,
       SUM(amo.mntfruits) AS total_fruit,
       SUM(amo.mntmeatproducts) AS total_meat,
       SUM(amo.mntfishproducts) AS total_fish,
       SUM(amo.mntsweetproducts) AS total_sweet,
       SUM(amo.mntgoldprods) AS total_gold,
       SUM(amo.mntwines + amo.mntfruits + amo.mntmeatproducts + amo.mntfishproducts + amo.mntsweetproducts + amo.mntgoldprods) AS total_all_products,
       SUM(pur.numwebpurchases) AS web_purchases,
       SUM(pur.numcatalogpurchases) AS catalog_purchases,
       SUM(pur.numstorepurchases) AS store_purchases,
       SUM(pur.numwebpurchases + pur.numcatalogpurchases + pur.numstorepurchases) AS total_purchases
FROM customers AS cus
JOIN amount AS amo
ON cus.id = amo.id
JOIN purchases AS pur
ON amo.id = pur.id
WHERE marital_status <> "Absurd" AND marital_status <> "YOLO"
GROUP BY cus.marital_status
ORDER BY n_of_clients DESC;


####################################
######## TYPE OF CUSTOMER ##########
####################################

-- Type of customers / average demographics/ favourite products/ way to purchase
SELECT DISTINCT CONCAT(cus.education, " ", cus.marital_status) AS most_frequent_client,
       COUNT(cus.id) AS n_of_clients,
       ROUND(AVG(2024 - cus.year_birth),0) AS average_age,
       ROUND(AVG(cus.income),1) AS average_income,
       ROUND(AVG(cus.kidhome + cus.teenhome),2) AS children_at_home,
       MAX(cus.kidhome + cus.teenhome) AS max_children_at_home,
       CASE
           WHEN GREATEST(SUM(amo.mntwines), SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntwines) THEN "Wine"
           WHEN GREATEST(SUM(amo.mntwines), SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntfruits) THEN "Fruit"
           WHEN GREATEST(SUM(amo.mntwines), SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntmeatproducts) THEN "Meat"
           WHEN GREATEST(SUM(amo.mntwines), SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntfishproducts) THEN "Fish"
           WHEN GREATEST(SUM(amo.mntwines), SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntsweetproducts) THEN "Sweet"
           WHEN GREATEST(SUM(amo.mntwines), SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntgoldprods) THEN "Gold"
		END AS "favourite_product",
        CASE
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntfruits) THEN "Fruit"
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntmeatproducts) THEN "Meat"
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntfishproducts) THEN "Fish"
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntsweetproducts) THEN "Sweet"
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntmeatproducts), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntgoldprods) THEN "Gold"
		END AS "2nd_favourite_product",
        CASE
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntfruits) THEN "Fruit"
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntfishproducts) THEN "Fish"
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntsweetproducts) THEN "Sweet"
           WHEN GREATEST(SUM(amo.mntfruits), SUM(amo.mntfishproducts), SUM(amo.mntsweetproducts), SUM(amo.mntgoldprods)
           ) = SUM(amo.mntgoldprods) THEN "Gold"
		END AS "3rd_favourite_product",
        CASE
			WHEN GREATEST(SUM(pur.numwebpurchases), SUM(pur.numcatalogpurchases), SUM(pur.numstorepurchases)
            ) = SUM(pur.numwebpurchases) THEN "Web"
            WHEN GREATEST(SUM(pur.numwebpurchases), SUM(pur.numcatalogpurchases), SUM(pur.numstorepurchases)
            ) = SUM(pur.numcatalogpurchases) THEN "Catalog" 
            WHEN GREATEST(SUM(pur.numwebpurchases), SUM(pur.numcatalogpurchases), SUM(pur.numstorepurchases)
            ) = SUM(pur.numstorepurchases) THEN "Store"
		END AS "favourite_way_to_purchase"
FROM customers AS cus
JOIN amount AS amo
ON cus.id = amo.id
JOIN purchases AS pur
ON amo.id = pur.id
WHERE marital_status <> "Absurd" AND marital_status <> "YOLO"
GROUP BY most_frequent_client
ORDER BY n_of_clients DESC;
