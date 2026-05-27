USE libraryDB;
GO


-- Kitap ödünç verme işlemi

CREATE PROCEDURE sp_BorrowBook
(
    @MemberID INT,
    @BookID INT,
    @DueDate DATE
)
AS
BEGIN

-- Stok kontrolü
    IF EXISTS (
        SELECT 1
        FROM Books
        WHERE BookID = @BookID
        AND StockQuantity <= 0
    )
    BEGIN
        PRINT 'Kitap stokta yok.';
        RETURN;
    END

-- Ödünç kaydı oluşturur
    INSERT INTO Borrowings
    (
        MemberID,
        BookID,
        BorrowDate,
        DueDate
    )
    VALUES
    (
        @MemberID,
        @BookID,
        GETDATE(),
        @DueDate
    );

-- Stok azaltır
    UPDATE Books
    SET StockQuantity = StockQuantity - 1
    WHERE BookID = @BookID;

    PRINT 'Kitap başarıyla ödünç verildi.';
END;
GO



-- Geciken kitap cezalarını hesapla

CREATE PROCEDURE sp_CreateLateFine
AS
BEGIN

    INSERT INTO Fines
    (
        BorrowingID,
        FineAmount,
        PaymentStatus,
        Reason
    )

    SELECT
        BR.BorrowingID,
        DATEDIFF(DAY, BR.DueDate, GETDATE()) * 5,
        'Unpaid',
        'Late Return'

    FROM Borrowings BR

    WHERE BR.ReturnDate IS NULL
    AND BR.DueDate < GETDATE()

    AND NOT EXISTS
    (
        SELECT 1
        FROM Fines F
        WHERE F.BorrowingID = BR.BorrowingID
    );

    PRINT 'Gecikme cezaları oluşturuldu.';
END;
GO



-- Üyenin ödünç geçmişi

CREATE PROCEDURE sp_MemberBorrowHistory
(
    @MemberID INT
)
AS
BEGIN

    SELECT
        M.FirstName,
        M.LastName,
        B.Title,
        BR.BorrowDate,
        BR.ReturnDate

    FROM Borrowings BR

    INNER JOIN Members M
        ON BR.MemberID = M.MemberID

    INNER JOIN Books B
        ON BR.BookID = B.BookID

    WHERE M.MemberID = @MemberID;

END;
GO

EXEC sp_BorrowBook
    @MemberID = 1,
    @BookID = 2,
    @DueDate = '2026-06-30';


EXEC sp_CreateLateFine;


EXEC sp_MemberBorrowHistory
    @MemberID = 1;
