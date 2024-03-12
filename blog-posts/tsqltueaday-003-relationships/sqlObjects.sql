--// Create tables for demo.
CREATE TABLE dbo.productCategory
(
	categoryId TINYINT IDENTITY(1,1) PRIMARY KEY,
	categoryName NVARCHAR(20) NOT NULL,
	categoryDescription NVARCHAR(100) NOT NULL
)
;

CREATE TABLE dbo.product
(
	productId SMALLINT IDENTITY(1,1) PRIMARY KEY,
	productCategoryId TINYINT NOT NULL,
	productName NVARCHAR(20) NOT NULL,
	productDescription NVARCHAR(100) NOT NULL,
	productPrice MONEY NOT NULL
)
;

CREATE TABLE dbo.sales
(
	salesId BIGINT IDENTITY(1,1) PRIMARY KEY,
	productId SMALLINT NOT NULL,
	productQuantity INT NOT NULL
)
;

--// Create relationships for the tables.
ALTER TABLE dbo.product
	ADD CONSTRAINT fk_productCategory FOREIGN KEY(productCategoryId)
		REFERENCES dbo.productCategory(categoryId)
;
ALTER TABLE dbo.sales
	ADD CONSTRAINT fk_product FOREIGN KEY(productId)
		REFERENCES dbo.product(productId)
;

--// Add some data to the tables.
INSERT dbo.productCategory
(categoryName,categoryDescription)
VALUES
(N'Motorcycle',N'Motorcyles'),
(N'Electronics',N'Electronic Accessories'),
(N'Luggage',N'Additional Luggage'),
(N'Performance',N'Performance Parts'),
(N'Parts',N'Components')
;

INSERT dbo.product
(productCategoryId,productName,productDescription,productPrice)
VALUES
(1,N'Tiger 1200 XCA',N'Triumph Tiger 1200 XCA',17995.00),
(1,N'Tiger 800 XCA',N'Triumph Tiger 800 XCA',12995.00),
(1,N'Speed Triple 1050 RS',N'Triumph Speed Triple 1050 RS',15995.00),
(2,N'TomTom Rider 550',N'TomTom SatNav Unit',395.99),
(4,N'Arrow GP2',N'Arrow Exhaust (ALU)',499.99),
(5,N'Sprocket F1242',N'7 Tooth Front Sprocket',49.99),
(5,N'Sprocket F4529',N'Performance Rear Sprocket',78.99),
(5,N'Serket Taper',N'Scorpion Exhaust (Carbon)',295.95)
;

INSERT dbo.sales
(productId, productQuantity)
VALUES
(1,1),
(2,1),
(1,2),
(2,1),
(3,1),
(4,2),
(3,1),
(3,1),
(3,1),
(3,1),
(5,2),
(6,1),
(7,1),
(8,1),
(8,1),
(1,1),
(3,1),
(1,1),
(4,1),
(1,1),
(5,1),
(1,1),
(7,1),
(7,2),
(4,1),
(4,1),
(4,1),
(4,1),
(4,1),
(4,1),
(2,1),
(3,1),
(2,1),
(2,1),
(1,1),
(2,1),
(1,1)
;

--// lOOKS AT THE DATA
SELECT s.salesId,
	p.productName,
	pc.categoryName,
	s.productQuantity
FROM dbo.sales AS s
JOIN dbo.product AS p
	ON s.productId = p.productId
JOIN dbo.productCategory AS pc
	ON p.productCategoryId = pc.categoryId
;

--// Drop and recreate the foreign keys
ALTER TABLE dbo.product
	DROP CONSTRAINT fk_productCategory
;
ALTER TABLE dbo.sales
	DROP CONSTRAINT fk_product
;
ALTER TABLE dbo.product
	ADD CONSTRAINT fk_productCategory FOREIGN KEY(productCategoryId)
		REFERENCES dbo.productCategory(categoryId)
		ON DELETE CASCADE
;
ALTER TABLE dbo.sales
	ADD CONSTRAINT fk_product FOREIGN KEY(productId)
		REFERENCES dbo.product(productId)
		ON DELETE CASCADE
;

BEGIN TRAN

	DELETE dbo.productCategory
		WHERE categoryId = 1
	;

	SELECT s.salesId,
		p.productName,
		pc.categoryName,
		s.productQuantity
	FROM dbo.sales AS s
	JOIN dbo.product AS p
		ON s.productId = p.productId
	JOIN dbo.productCategory AS pc
		ON p.productCategoryId = pc.categoryId
	;

    SELECT COUNT(*) AS dataRows
    FROM dbo.sales
    ;

ROLLBACK
