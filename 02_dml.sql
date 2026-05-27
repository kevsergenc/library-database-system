USE libraryDB;

INSERT INTO Authors (FirstName, LastName, BirthYear, Nationality)
VALUES 
    ('Fyodor', 'Dostoevsky', 1821, 'Russian'),
    ('George', 'Orwell', 1903, 'British'),
    ('Sabahattin', 'Ali', 1907, 'Turkish'),
    ('Agatha', 'Christie', 1890, 'British'),
    ('Stephen', 'King', 1947, 'American'),
    ('Victor', 'Hugo', 1802, 'French'),
    ('Yaþar', 'Kemal', 1923, 'Turkish'),
    ('J.K.', 'Rowling', 1965, 'British'),
    ('Gabriel', 'García Márquez', 1927, 'Colombian'),
    ('Jane', 'Austen', 1775, 'British'),
    ('Haruki', 'Murakami', 1949, 'Japanese'),
    ('Franz', 'Kafka', 1883, 'Austrian');

INSERT INTO Categories (CategoryName, TargetAudience)
VALUES 
    ('Science Fiction', 'General'),
    ('Fantasy', 'General'),
    ('Romance', 'Adults'),
    ('Thriller & Suspense', 'Adults'),
    ('Historical Fiction', 'General'),
    ('Biography & Memoir', 'General'),
    ('Computer Science', 'Academic'),
    ('Data Science & AI', 'Academic'),
    ('Philosophy', 'Academic'),
    ('Children''s Literature', 'Children'),
    ('Young Adult', 'Teens'),
    ('Self-Help & Psychology', 'Adults');

INSERT INTO Publishers (PublisherName, City, PhoneNumber, Website)
VALUES 
    ('Penguin Books', 'London', '+442071393000', 'penguin.co.uk'),
    ('Oxford University Press', 'Oxford', '+441865556767', 'oup.com'),
    ('Can Yayýnlarý', 'Ýstanbul', '02122525675', 'canyayinlari.com'),
    ('Ýþ Bankasý Kültür Yayýnlarý', 'Ýstanbul', '02122523035', 'iskultur.com.tr'),
    ('HarperCollins', 'New York', '+12122077000', 'harpercollins.com'),
    ('Vintage', 'London', '+442078408400', 'penguin.co.uk/vintage'),
    ('Simon & Schuster', 'New York', '+12126987000', 'simonandschuster.com'),
    ('Bloomsbury', 'London', '+442076315600', 'bloomsbury.com'),
    ('O''Reilly Media', 'California', '+17078277000', 'oreilly.com'),
    ('Pearson', 'London', '+442070102000', 'pearson.com'),
    ('Ýletiþim Yayýnlarý', 'Ýstanbul', '02125169260', 'iletisim.com.tr');

INSERT INTO Shelves (ShelfCode, FloorNumber, SectionName, Capacity)
VALUES 
    ('F0-S01-R01', 0, 'Reference', 30),
    ('F1-S02-R01', 1, 'Science Fiction', 60),
    ('F1-S02-R02', 1, 'Science Fiction', 60),
    ('F1-S03-R01', 1, 'Fantasy', 50),
    ('F2-S04-R01', 2, 'History', 45),
    ('F2-S05-R01', 2, 'Philosophy', 40),
    ('F3-S06-R01', 3, 'Computer Science', 55),
    ('F3-S06-R02', 3, 'Data Science & AI', 55),
    ('F4-S07-R01', 4, 'Academic Journals', 100),
    ('F4-S08-R01', 4, 'Biography', 50),
    ('F5-S09-R01', 5, 'Rare Books', 20),
    ('F0-S10-R01', 0, 'Childrens Literature', 40);

INSERT INTO Books (ISBN, Title, AuthorID, CategoryID, ShelfID, PageCount, StockQuantity, PublishedYear, PublisherID)
VALUES 
    ('9780451524935', '1984', 2, 1, 2, 328, 5, 1949, 1),
    ('9780140449136', 'Crime and Punishment', 1, 5, 5, 671, 3, 1866, 6),
    ('9789750719387', 'Madonna in a Fur Coat', 3, 3, 4, 160, 10, 1943, 3),
    ('9780007117116', 'Murder on the Orient Express', 4, 4, 2, 256, 4, 1934, 5),
    ('9780385121675', 'The Shining', 5, 4, 3, 447, 6, 1977, 7),
    ('9780261103573', 'The Fellowship of the Ring', 8, 2, 4, 423, 8, 1954, 8),
    ('9780141393392', 'Les Misérables', 6, 5, 5, 1463, 2, 1862, 1),
    ('9780593230480', 'The Art of Statistics', 7, 8, 8, 448, 5, 2019, 9),
    ('9780571190638', 'The Metamorphosis', 12, 5, 5, 102, 12, 1915, 6),
    ('9784087741025', 'Norwegian Wood', 11, 3, 10, 296, 7, 1987, 6),
    ('9780143039662', 'One Hundred Years of Solitude', 9, 2, 4, 417, 4, 1967, 1),
    ('9780140444254', 'Sense and Sensibility', 10, 3, 10, 409, 3, 1811, 1);

INSERT INTO Members (FirstName, LastName, Email, TCNo, PhoneNumber, MemberStatus)
VALUES 
    ('Feyza', 'Demir', 'feyza.demir@example.com', '12345678901', '05551112233', 'Active'),
    ('Ahmet', 'Yýlmaz', 'ahmet.yilmaz@example.com', '23456789012', '05552223344', 'Active'),
    ('Elif', 'Kaya', 'elif.kaya@example.com', '34567890123', '05553334455', 'Active'),
    ('Mehmet', 'Öztürk', 'mehmet.ozturk@example.com', '45678901234', '05554445566', 'Active'),
    ('Selin', 'Arslan', 'selin.arslan@example.com', '56789012345', '05555556677', 'Passive'),
    ('Can', 'Yýldýz', 'can.yildiz@example.com', '67890123456', '05556667788', 'Active'),
    ('Deniz', 'Bulut', 'deniz.bulut@example.com', '78901234567', '05557778899', 'Active'),
    ('Merve', 'Güneþ', 'merve.gunes@example.com', '89012345678', '05558889900', 'Suspended'),
    ('Burak', 'Þahin', 'burak.sahin@example.com', '90123456789', '05559990011', 'Active'),
    ('Zeynep', 'Aydýn', 'zeynep.aydin@example.com', '01234567890', '05550001122', 'Active'),
    ('Emre', 'Çelik', 'emre.celik@example.com', '11223344556', '05551234567', 'Active'),
    ('Aslý', 'Sönmez', 'asli.sonmez@example.com', '22334455667', '05559876543', 'Active');

INSERT INTO Borrowings (MemberID, BookID, BorrowDate, DueDate, ReturnDate)
VALUES 
    (1, 1, '2026-05-01', '2026-05-15', '2026-05-12'),
    (2, 3, '2026-05-02', '2026-05-16', '2026-05-14'),
    (3, 2, '2026-05-03', '2026-05-17', NULL), -- Henüz iade edilmedi
    (4, 5, '2026-05-04', '2026-05-18', '2026-05-18'),
    (5, 4, '2026-05-05', '2026-05-19', NULL),
    (6, 6, '2026-05-06', '2026-05-20', '2026-05-19'),
    (7, 8, '2026-05-07', '2026-05-21', NULL),
    (8, 7, '2026-04-20', '2026-05-04', '2026-05-06'), -- Gecikmeli iade
    (9, 10, '2026-05-08', '2026-05-22', NULL),
    (10, 9, '2026-05-09', '2026-05-23', '2026-05-22'),
    (1, 11, '2026-05-10', '2026-05-24', NULL),
    (2, 12, '2026-05-11', '2026-05-25', NULL);

INSERT INTO Fines (BorrowingID, FineAmount, PaymentStatus, Reason)
VALUES 
    (1, 15.50, 'Paid', 'Late Return'),
    (2, 5.00, 'Paid', 'Late Return'),
    (4, 2.75, 'Unpaid', 'Late Return'),
    (6, 10.00, 'Unpaid', 'Late Return'),
    (8, 25.00, 'Unpaid', 'Damaged Book'),
    (10, 4.50, 'Paid', 'Late Return'),
    (3, 12.00, 'Unpaid', 'Late Return'),
    (5, 8.25, 'Unpaid', 'Late Return'),
    (7, 30.00, 'Unpaid', 'Lost Book'),
    (9, 6.50, 'Paid', 'Late Return'),
    (11, 2.00, 'Unpaid', 'Late Return');


