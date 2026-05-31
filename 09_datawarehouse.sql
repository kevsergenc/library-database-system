USE libraryDB;
GO


CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    Year INT,
    Month INT,
    Quarter INT
);

CREATE TABLE DimCategory (
    CategoryKey INT PRIMARY KEY,
    CategoryName NVARCHAR(50),
    TargetAudience NVARCHAR(20)
);

CREATE TABLE FactLibraryMetrics (
    FactID INT IDENTITY(1,1) PRIMARY KEY,
    DateKey INT,
    CategoryKey INT,
    TotalBorrows INT,
    TotalFines DECIMAL(10,2)
);
GO

-- ETL İŞLEMİ
-- (Sistemin veri ambarı olduğunu ispatlamak için temsili doldurma)

INSERT INTO DimDate (DateKey, Year, Month, Quarter)
SELECT DISTINCT 
    CAST(FORMAT(BorrowDate, 'yyyyMMdd') AS INT), 
    YEAR(BorrowDate), 
    MONTH(BorrowDate), 
    DATEPART(QQ, BorrowDate)
FROM Borrowings;

INSERT INTO DimCategory (CategoryKey, CategoryName, TargetAudience)
SELECT CategoryID, CategoryName, TargetAudience FROM Categories;

INSERT INTO FactLibraryMetrics (DateKey, CategoryKey, TotalBorrows, TotalFines)
SELECT 
    CAST(FORMAT(br.BorrowDate, 'yyyyMMdd') AS INT) AS DateKey,
    b.CategoryID AS CategoryKey,
    COUNT(br.BorrowingID) AS TotalBorrows,
    SUM(ISNULL(f.FineAmount, 0)) AS TotalFines
FROM Borrowings br
JOIN Books b ON br.BookID = b.BookID
LEFT JOIN Fines f ON br.BorrowingID = f.BorrowingID
GROUP BY CAST(FORMAT(br.BorrowDate, 'yyyyMMdd') AS INT), b.CategoryID;
GO


--OLAP SORGULARI


-- Yıl ve Kategori Çapraz Analizi (Alt toplamlar ve genel toplam verir)
SELECT 
    d.Year AS Yil,
    c.CategoryName AS Kategori,
    SUM(f.TotalBorrows) AS ToplamOdunc,
    SUM(f.TotalFines) AS ToplamCeza
FROM FactLibraryMetrics f
JOIN DimDate d ON f.DateKey = d.DateKey
JOIN DimCategory c ON f.CategoryKey = c.CategoryKey
GROUP BY CUBE (d.Year, c.CategoryName);
GO

-- ROLLUP KULLANIMI: Hedef Kitle (TargetAudience) ve Kategori bazlı özet (Hiyerarşik toplam)
SELECT 
    c.TargetAudience AS HedefKitle,
    c.CategoryName AS Kategori,
    SUM(f.TotalBorrows) AS ToplamOduncSayisi
FROM FactLibraryMetrics f
JOIN DimCategory c ON f.CategoryKey = c.CategoryKey
GROUP BY ROLLUP (c.TargetAudience, c.CategoryName);
GO
