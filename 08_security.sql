/* Role, Grant ve Revoke için */

USE libraryDB;
GO

-- 1. Roller Oluşturuluyor
CREATE ROLE db_library_reader; -- Sadece okuma yapabilen rol (Örn: Öğrenciler/Ziyaretçiler)
CREATE ROLE db_library_staff;  -- İşlem yapabilen rol (Örn: Kütüphane Görevlileri)

-- 2. Yetki Verme (GRANT)
-- Ziyaretçiler kitapları ve kategorileri görebilir
GRANT SELECT ON Books TO db_library_reader;
GRANT SELECT ON Categories TO db_library_reader;

-- Kütüphane görevlileri ana tabloları yönetebilir
GRANT SELECT, INSERT, UPDATE, DELETE ON Books TO db_library_staff;
GRANT SELECT, INSERT, UPDATE ON Borrowings TO db_library_staff;
GRANT SELECT, INSERT, UPDATE ON Members TO db_library_staff;
GRANT SELECT, INSERT, UPDATE ON Fines TO db_library_staff;

-- Kütüphane görevlilerinin oluşturulan prosedürleri çalıştırmasına izin ver
GRANT EXECUTE ON sp_ReturnBook_Tx TO db_library_staff;
GRANT EXECUTE ON sp_PayFine_Tx TO db_library_staff;

-- 3. Yetki Geri Alma/Kısıtlama (REVOKE)
-- Görevlilerin "Members" tablosundan üye silmesini kesinlikle engelle
REVOKE DELETE ON Members FROM db_library_staff;
GO
