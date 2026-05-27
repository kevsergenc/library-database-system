USE libraryDB;
GO


-- Üyelerin ödünç aldığı kitaplar

SELECT 
    M.FirstName,
    M.LastName,
    B.Title,
    BR.BorrowDate,
    BR.DueDate
FROM Borrowings BR
INNER JOIN Members M
    ON BR.MemberID = M.MemberID
INNER JOIN Books B
    ON BR.BookID = B.BookID;


-- Tüm üyeler ve varsa ceza bilgileri

SELECT 
    M.FirstName,
    M.LastName,
    F.FineAmount,
    F.PaymentStatus
FROM Members M
LEFT JOIN Borrowings BR
    ON M.MemberID = BR.MemberID
LEFT JOIN Fines F
    ON BR.BorrowingID = F.BorrowingID;


-- Tüm kitaplar ve ödünç kayıtları

SELECT 
    B.Title,
    BR.BorrowingID,
    BR.BorrowDate
FROM Books B
FULL JOIN Borrowings BR
    ON B.BookID = BR.BookID;


-- Aynı soyada sahip üyeler

SELECT 
    M1.FirstName AS Uye1_Ad,
    M1.LastName AS Ortak_Soyad,
    M2.FirstName AS Uye2_Ad
FROM Members M1
INNER JOIN Members M2
    ON M1.LastName = M2.LastName
    AND M1.MemberID <> M2.MemberID;


-- Her kategorideki kitap sayısı

SELECT 
    C.CategoryName,
    COUNT(B.BookID) AS KitapSayisi
FROM Categories C
INNER JOIN Books B
    ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryName;


-- 2’den fazla kitabı olan kategoriler

SELECT 
    C.CategoryName,
    COUNT(B.BookID) AS KitapSayisi
FROM Categories C
INNER JOIN Books B
    ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryName
HAVING COUNT(B.BookID) > 2;


-- Cezası olan üyeler

SELECT 
    FirstName,
    LastName
FROM Members
WHERE MemberID IN
(
    SELECT BR.MemberID
    FROM Borrowings BR
    INNER JOIN Fines F
        ON BR.BorrowingID = F.BorrowingID
);


-- Ödünç alınmış kitaplar

SELECT 
    Title
FROM Books B
WHERE EXISTS
(
    SELECT 1
    FROM Borrowings BR
    WHERE BR.BookID = B.BookID
);


-- Kategorilere göre toplam stok

SELECT 
    C.CategoryName,
    SUM(B.StockQuantity) AS ToplamStok
FROM Books B
INNER JOIN Categories C
    ON B.CategoryID = C.CategoryID
GROUP BY ROLLUP(C.CategoryName);


-- En çok ödünç alınan kitaplar

SELECT 
    B.Title,
    COUNT(BR.BorrowingID) AS OduncSayisi
FROM Books B
INNER JOIN Borrowings BR
    ON B.BookID = BR.BookID
GROUP BY B.Title
ORDER BY OduncSayisi DESC;
