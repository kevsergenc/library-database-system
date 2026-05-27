USE libraryDB;
GO

-- Kitap detayları

CREATE VIEW vw_BookDetails
AS
SELECT
    B.BookID,
    B.Title,
    A.FirstName + ' ' + A.LastName AS AuthorName,
    C.CategoryName,
    P.PublisherName,
    B.StockQuantity
FROM Books B
INNER JOIN Authors A
    ON B.AuthorID = A.AuthorID
INNER JOIN Categories C
    ON B.CategoryID = C.CategoryID
INNER JOIN Publishers P
    ON B.PublisherID = P.PublisherID;
GO



-- Aktif ödünç kitaplar

CREATE VIEW vw_ActiveBorrowings
AS
SELECT
    M.FirstName + ' ' + M.LastName AS MemberName,
    B.Title,
    BR.BorrowDate,
    BR.DueDate
FROM Borrowings BR
INNER JOIN Members M
    ON BR.MemberID = M.MemberID
INNER JOIN Books B
    ON BR.BookID = B.BookID
WHERE BR.ReturnDate IS NULL;
GO



-- Kategorilere göre kitap sayısı


CREATE VIEW vw_CategoryBookCount
AS
SELECT
    C.CategoryName,
    COUNT(B.BookID) AS BookCount
FROM Categories C
LEFT JOIN Books B
    ON C.CategoryID = B.CategoryID
GROUP BY C.CategoryName;
GO

SELECT * FROM vw_BookDetails;

SELECT * FROM vw_ActiveBorrowings;

SELECT * FROM vw_CategoryBookCount;
