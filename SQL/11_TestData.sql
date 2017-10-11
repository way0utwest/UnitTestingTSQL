/*
Unit Testing T-SQL - Selective Test Data loads

Steve Jones, copyright 2017

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/
USE TestingTSQL;
GO

-- We want to ensure we have a known set of test data
-- Set a table to 1 to reload
DECLARE
    @SalesTax BIT = 0
    , @SalesOrderDetail BIT = 1
--  , @Customer bit = 0
--  , @Supplier bit = 0
--  , @SupplierRegion bit = 0
--  , @SalesOrderHeader bit = 0
;





-- Check the flags to clear tables
IF @SalesOrderDetail = 1
    TRUNCATE TABLE dbo.SalesOrderDetail;
IF @SalesTax = 1
    TRUNCATE TABLE dbo.Salestax;
-- ...

-- check the flags to reload the table
IF @SalesOrderDetail = 1
    INSERT INTO dbo.SalesOrderDetail
    (   SalesOrderID,
        SalesOrderDetailID,
        OrderQuantity,
        ProductID,
        UnitPrice,
        DiscountPercent,
        LineTotal,
        TaxAmount,
        ShippingState
    )
    VALUES
    (
        1, 1, 10, 2, 10, 0.0, 100, 2, 'PA'
    ),
    (
        1, 2, 22, 3, 5, 0.1, 100, 5, 'GA'
    ),
    (
        2, 3, 5, 2, 4, 0.15, 17, 0.85, 'GA'
    ),
    (
        2, 4, 12, 3, 10, 0.1, 108, 2.268, 'CO'
    ),
    (
        2, 5, 5, 4, 60, 0.0, 300, 18.60, 'CA'
    );
IF @SalesTax = 1
    INSERT dbo.Salestax
    (   statecode,
        taxamount
    )
    VALUES
    (
        'AK', 0.0714
    ),
    (
        'AL', 0.0214
    ),
    (
        'AR', 0.034
    ),
    (
        'AZ', 0.011
    ),
    (
        'CA', 0.062
    ),
    (
        'CO', 0.021
    ),
    (
        'CT', 0.064
    ),
    (
        'DE', 0.032
    ),
    (
        'FL', 0.06
    ),
    (
        'GA', 0.05
    ),
    (
        'HI', 0.08
    ),
    (
        'IA', 0.044
    ),
    (
        'ID', 0.031
    ),
    (
        'IL', 0.074
    ),
    (
        'IN', 0.071
    ),
    (
        'KS', 0.074
    ),
    (
        'KY', 0.074
    ),
    (
        'LA', 0.071
    ),
    (
        'MA', 0.071
    ),
    (
        'MD', 0.071
    ),
    (
        'ME', 0.074
    ),
    (
        'MI', 0.0714
    ),
    (
        'MN', 0.0714
    ),
    (
        'MO', 0.0714
    ),
    (
        'MS', 0.0714
    ),
    (
        'MT', 0.0714
    ),
    (
        'NC', 0.0714
    ),
    (
        'ND', 0.0714
    ),
    (
        'NE', 0.0714
    ),
    (
        'NH', 0.0714
    ),
    (
        'NJ', 0.0714
    ),
    (
        'NM', 0.0714
    ),
    (
        'NV', 0.0714
    ),
    (
        'NY', 0.0714
    ),
    (
        'OH', 0.0714
    ),
    (
        'OK', 0.0714
    ),
    (
        'OR', 0.0714
    ),
    (
        'PA', 0.02
    ),
    (
        'RI', 0.0714
    ),
    (
        'SC', 0.0714
    ),
    (
        'SD', 0.0714
    ),
    (
        'TN', 0.0714
    ),
    (
        'TX', 0.0714
    ),
    (
        'UT', 0.0714
    ),
    (
        'VA', 0.0714
    ),
    (
        'VT', 0.074
    ),
    (
        'WA', 0.071
    ),
    (
        'WI', 0.024
    ),
    (
        'WV', 0.014
    ),
    (
        'WY', 0.014
    );
GO