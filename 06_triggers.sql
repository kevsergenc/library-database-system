/* En az 2 Trigger: 1 Loglama, 1 İş Kuralı için */

USE libraryDB;
GO

-- 1. Loglama Tablosu (Trigger'ın çalışacağı hedef)
CREATE TABLE SystemLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50),
    ActionType NVARCHAR(50),
    RecordID INT,
    ActionDate DATETIME DEFAULT GETDATE()
);
GO

-- TRIGGER 1: AFTER INSERT Loglama (Yeni üye eklendiğinde log atar)
CREATE TRIGGER trg_LogNewMember
ON Members
AFTER INSERT
AS
BEGIN
    INSERT INTO SystemLogs (TableName, ActionType, RecordID)
    SELECT 'Members', 'INSERT - Yeni Uye', MemberID
    FROM inserted;
END;
GO

-- TRIGGER 2: İş Kuralı (Pasif veya Askıya Alınmış üyelerin kitap almasını engeller)
CREATE TRIGGER trg_PreventBorrowing
ON Borrowings
AFTER INSERT
AS
BEGIN
    -- Eklenen kayıtlardan, statüsü 'Active' olmayanları tespit et
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        INNER JOIN Members m ON i.MemberID = m.MemberID
        WHERE m.MemberStatus <> 'Active'
    )
    BEGIN
        RAISERROR ('İşlem reddedildi: Sadece Aktif (Active) üyeler kitap ödünç alabilir.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
