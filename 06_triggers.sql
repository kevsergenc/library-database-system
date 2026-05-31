USE libraryDB;
GO

CREATE TABLE SystemLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50),
    ActionType NVARCHAR(50),
    RecordID INT,
    ActionDate DATETIME DEFAULT GETDATE()
);
GO

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

CREATE TRIGGER trg_PreventBorrowing
ON Borrowings
AFTER INSERT
AS
BEGIN
    -- Eklenen kayıtlardan, statüsü 'Active' olmayanları tespit eder
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

INSERT INTO Members
(
    FirstName,
    LastName,
    Email,
    TCNo,
    PhoneNumber,
    MemberStatus
)
VALUES
(
    'Test',
    'Kullanici',
    'test@example.com',
    '99999999999',
    '05550000000',
    'Active'
);

SELECT * FROM SystemLogs;

INSERT INTO Members
(
    FirstName,
    LastName,
    Email,
    TCNo,
    PhoneNumber,
    MemberStatus
)
VALUES
(
    'Pasif',
    'Uye',
    'pasif@example.com',
    '88888888888',
    '05551111111',
    'Passive'
);

SELECT *
FROM Members
WHERE Email='pasif@example.com';

INSERT INTO Borrowings
(
    MemberID,
    BookID,
    BorrowDate,
    DueDate
)
VALUES
(
    14,
    1,
    GETDATE(),
    DATEADD(DAY,14,GETDATE())
);

SELECT *
FROM Borrowings
WHERE MemberID = 14;


