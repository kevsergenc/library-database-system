/* En az 3 Transaction bloğu, En az 1 TRY/CATCH ve İzolasyon Seviyesi için */

USE libraryDB;
GO

-- TRANSACTION 1: Kitap İade ve Ceza Kesme Senaryosu (TRY...CATCH İçerir)
CREATE PROCEDURE sp_ReturnBook_Tx
    @BorrowingID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @BookID INT, @DueDate DATE;
        
        SELECT @BookID = BookID, @DueDate = DueDate 
        FROM Borrowings WHERE BorrowingID = @BorrowingID AND ReturnDate IS NULL;
        
        IF @BookID IS NULL
            THROW 50001, 'Kayıt bulunamadı veya kitap zaten iade edilmiş.', 1;

        -- İade tarihini güncelle
        UPDATE Borrowings SET ReturnDate = GETDATE() WHERE BorrowingID = @BorrowingID;
        
        -- Stoğu artır
        UPDATE Books SET StockQuantity = StockQuantity + 1 WHERE BookID = @BookID;
        
        -- Gecikme varsa ceza oluştur
        IF CAST(GETDATE() AS DATE) > @DueDate
        BEGIN
            DECLARE @FineAmount DECIMAL(10,2) = DATEDIFF(DAY, @DueDate, GETDATE()) * 2.00;
            INSERT INTO Fines (BorrowingID, FineAmount, PaymentStatus, Reason)
            VALUES (@BorrowingID, @FineAmount, 'Unpaid', 'Late Return');
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO

-- TRANSACTION 2: Ceza Ödeme Senaryosu
CREATE PROCEDURE sp_PayFine_Tx
    @FineID INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    -- Cezayı ödenmiş olarak işaretle
    UPDATE Fines 
    SET PaymentStatus = 'Paid' 
    WHERE FineID = @FineID AND PaymentStatus = 'Unpaid';
    
    -- Eğer güncelleme başarılıysa (etkilenen satır 1 ise) onayla, değilse geri al
    IF @@ROWCOUNT = 1
        COMMIT TRANSACTION;
    ELSE
        ROLLBACK TRANSACTION;
END;
GO

-- TRANSACTION 3: Yeni Kategori ve Kitap Ekleme Senaryosu (Zincirleme İşlem)
CREATE PROCEDURE sp_AddNewCategoryAndBook_Tx
    @CatName NVARCHAR(50), @TargetAud NVARCHAR(20),
    @ISBN VARCHAR(13), @Title NVARCHAR(200), @AuthID INT, @PubID INT, @ShelfID INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    DECLARE @NewCatID INT;
    
    -- Kategori Ekle
    INSERT INTO Categories (CategoryName, TargetAudience) VALUES (@CatName, @TargetAud);
    SET @NewCatID = SCOPE_IDENTITY();
    
    -- Kitap Ekle
    INSERT INTO Books (ISBN, Title, AuthorID, CategoryID, PublisherID, ShelfID, StockQuantity)
    VALUES (@ISBN, @Title, @AuthID, @NewCatID, @PubID, @ShelfID, 5);
    
    -- Herhangi bir aşamada hata(@@ERROR) olduysa geri al, yoksa onayla
    IF @@ERROR <> 0
        ROLLBACK TRANSACTION;
    ELSE
        COMMIT TRANSACTION;
END;
GO
