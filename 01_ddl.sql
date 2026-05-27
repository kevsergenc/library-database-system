CREATE DATABASE libraryDB;

USE libraryDB;

CREATE TABLE Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY, 
    FirstName NVARCHAR(50) NOT NULL,       
    LastName NVARCHAR(50) NOT NULL,         
    BirthYear INT CHECK (BirthYear > -3000 AND BirthYear <= YEAR(GETDATE())), 
    Nationality NVARCHAR(50) DEFAULT 'Unknown', 

    CONSTRAINT UQ_Author_Name UNIQUE (FirstName, LastName) 
);

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY, 
    CategoryName NVARCHAR(50) NOT NULL,       
    TargetAudience NVARCHAR(20) DEFAULT 'General' 
        CHECK (TargetAudience IN ('Children', 'Teens', 'Adults', 'General', 'Academic')), 

    CONSTRAINT UQ_CategoryName UNIQUE (CategoryName) 
);

CREATE TABLE Publishers (
    PublisherID INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName NVARCHAR(100) NOT NULL,
    City NVARCHAR(50),
    PhoneNumber CHAR(15),
    Website NVARCHAR(100),

    CONSTRAINT UQ_PublisherName UNIQUE (PublisherName)
);

CREATE TABLE Shelves (
    ShelfID INT IDENTITY(1,1) PRIMARY KEY, 
    ShelfCode VARCHAR(20) NOT NULL,        
    FloorNumber INT NOT NULL,
    SectionName NVARCHAR(50) NOT NULL,
    Capacity INT DEFAULT 50,

    CONSTRAINT CHK_Floor CHECK (FloorNumber >= 0 AND FloorNumber <= 5),
    CONSTRAINT CHK_Capacity CHECK (Capacity > 0),
    CONSTRAINT UQ_ShelfCode UNIQUE (ShelfCode)
);

CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(13) NOT NULL UNIQUE,
    Title NVARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    CategoryID INT NOT NULL,
	PublisherID INT NOT NULL,
    ShelfID INT NOT NULL,
    PageCount INT CHECK (PageCount > 0),
    StockQuantity INT DEFAULT 1 CHECK (StockQuantity >= 0),
    PublishedYear INT DEFAULT YEAR(GETDATE()),

    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
	FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID),
    FOREIGN KEY (ShelfID) REFERENCES Shelves(ShelfID)
);

CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    TCNo CHAR(11) NOT NULL UNIQUE,
    MembershipDate DATE DEFAULT GETDATE(),
    PhoneNumber CHAR(11),
    MemberStatus NVARCHAR(20) DEFAULT 'Active' 
        CHECK (MemberStatus IN ('Active', 'Passive', 'Suspended')), 
   
    CONSTRAINT CHK_TCNo_Format CHECK (TCNo NOT LIKE '%[^0-9]%' AND LEN(TCNo) = 11)
);

CREATE TABLE Borrowings (
    BorrowingID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    BorrowDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    
    CONSTRAINT CHK_Dates CHECK (DueDate >= BorrowDate),
	CONSTRAINT CHK_MaxBorrowDays
    CHECK (DATEDIFF(DAY, BorrowDate, DueDate) <= 60),
    
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE Fines (
    FineID INT IDENTITY(1,1) PRIMARY KEY,
    BorrowingID INT NOT NULL,
    FineAmount DECIMAL(10, 2) NOT NULL,
    PaymentStatus NVARCHAR(20) DEFAULT 'Unpaid' 
        CHECK (PaymentStatus IN ('Paid', 'Unpaid', 'Cancelled')),
    FineDate DATE DEFAULT GETDATE(),
    Reason NVARCHAR(100) DEFAULT 'Late Return',
    
    CONSTRAINT CHK_FineAmount CHECK (FineAmount >= 0),

    FOREIGN KEY (BorrowingID) REFERENCES Borrowings(BorrowingID)
);



