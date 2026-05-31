USE libraryDB;
GO

CREATE ROLE db_library_reader; 
CREATE ROLE db_library_staff; 

GRANT SELECT ON Books TO db_library_reader;
GRANT SELECT ON Categories TO db_library_reader;

GRANT SELECT, INSERT, UPDATE, DELETE ON Books TO db_library_staff;
GRANT SELECT, INSERT, UPDATE ON Borrowings TO db_library_staff;
GRANT SELECT, INSERT, UPDATE ON Members TO db_library_staff;
GRANT SELECT, INSERT, UPDATE ON Fines TO db_library_staff;

GRANT EXECUTE ON sp_ReturnBook_Tx TO db_library_staff;
GRANT EXECUTE ON sp_PayFine_Tx TO db_library_staff;

-- Görevlilerin "Members" tablosundan üye silmesini kesinlikle engeller
REVOKE DELETE ON Members FROM db_library_staff;
GO
