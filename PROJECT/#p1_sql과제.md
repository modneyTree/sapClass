1. 설치
2. 데이터베이스 설계
명세 : 
- 5개 이상의 릴레이션, 하나 이상의 외래키를 포함하는 릴레이션을 2개 만들어야함
- 각 릴레이션의 스키마 생성을 위한 명령어 실행과 실행 결과를 화면 캡처해야 함.

내가 만들 주제 : 도서 유통 시스템(구매 part) : 구매 마스터
일반데이터 : 구매처번호, 구매처명, 국가키, 구매처 그룹, 개인번호, 사업자번호, 주소
회사데이터 : 구매처번호, 회사코드, 삭제지시자, 계정, 지급조건
구매조직마스터데이터 : 구매처번호, 구매조직, 구매그룹, 삭제지시자, 구매오더통화, 세금코드
도서 테이블 : 도서명, 저자, 출판사, 출판일, isbn, 국내국외구분, 십진분류표, 장르
도서 종류 테이블 : 장르id, 장르 이름, 분류 코드, 장르 설명

1.1. 도서 테이블 (Book)
목적: 도서의 기본 정보를 저장
필드:
BookID (PK): 도서 고유 ID (자동 증가 정수)
Title: 도서명
Author: 저자
Publisher: 출판사
PublicationDate: 출판일 (DATE)
ISBN: 국제표준도서번호
DomesticOrForeign: 국내/국외 구분 (VARCHAR 또는 ENUM)
Classification: 십진분류표 코드
GenreID (FK): 장르 ID (외래키, 도서 종류 테이블 참조)

1.2. 도서 종류 테이블 (BookGenre)
목적: 도서의 장르, 카테고리, 기타 구분 정보를 저장
필드:
GenreID (PK): 장르 고유 ID
GenreName: 장르 이름 (예: 소설, 과학, 역사)
CategoryCode: 분류 코드 (예: KDC, DDC)
Description: 장르 설명

2. 릴레이션 검토
릴레이션의 외래키와 주요 관계는 아래와 같습니다:

Book -> BookGenre:
1:N 관계: 하나의 장르에 여러 도서가 속할 수 있음.
외래키: Book.GenreID -> BookGenre.GenreID

3. SQL 스키마 생성(구매 마스터)
```sql
-- 일반 데이터 테이블(GeneralData)
CREATE TABLE GeneralData (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,  -- 구매처 번호
    CustomerName VARCHAR(100) NOT NULL, -- 구매처명
    CountryKey VARCHAR(50),     -- 국가키
    CustomerGroup VARCHAR(50),  -- 구매처 그룹
    PersonalID VARCHAR(50),     -- 개인번호
    BusinessID VARCHAR(50),     -- 사업자번호
    Address VARCHAR(255)        -- 주소
);

INSERT INTO GeneralData (CustomerName, CountryKey, CustomerGroup, PersonalID, BusinessID, Address)
VALUES
('Book Supplier A', 'KR', 'Group1', '123456789', '987654321', 'Seoul, South Korea'),
('Book Supplier B', 'US', 'Group2', '123123123', '987987987', 'New York, USA');

-- 회사 데이터 테이블
CREATE TABLE CompanyData (
    CustomerID INT,
    CompanyCode VARCHAR(50),
    DeleteIndicator CHAR(1),
    Account VARCHAR(50),
    PaymentTerms VARCHAR(50),
    PRIMARY KEY (CustomerID, CompanyCode),
    FOREIGN KEY (CustomerID) REFERENCES GeneralData(CustomerID)
);

INSERT INTO CompanyData (CustomerID, CompanyCode, DeleteIndicator, Account, PaymentTerms)
VALUES
(1, 'C001', 'N', 'AC123', 'Net30'),
(2, 'C002', 'N', 'AC456', 'Net60');

-- 구매 조직 마스터 데이터 테이블
CREATE TABLE PurchaseOrgMaster (
    CustomerID INT,
    PurchaseOrg VARCHAR(50),
    PurchaseGroup VARCHAR(50),
    DeleteIndicator CHAR(1),
    PurchaseOrderCurrency VARCHAR(10),
    TaxCode VARCHAR(10),
    PRIMARY KEY (CustomerID, PurchaseOrg),
    FOREIGN KEY (CustomerID) REFERENCES GeneralData(CustomerID)
);

INSERT INTO PurchaseOrgMaster (CustomerID, PurchaseOrg, PurchaseGroup, DeleteIndicator, PurchaseOrderCurrency, TaxCode)
VALUES
(1, 'P001', 'Group1', 'N', 'KRW', 'T1'),
(2, 'P002', 'Group2', 'N', 'USD', 'T2');

-- 도서 테이블
CREATE TABLE Book (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(100),
    Publisher VARCHAR(100),
    PublicationDate DATE,
    ISBN VARCHAR(20) UNIQUE,
    DomesticOrForeign ENUM('Domestic', 'Foreign'),
    Classification VARCHAR(20),
    GenreID INT,
    FOREIGN KEY (GenreID) REFERENCES BookGenre(GenreID)
);

INSERT INTO Book (Title, Author, Publisher, PublicationDate, ISBN, DomesticOrForeign, Classification, GenreID)
VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', '1925-04-10', '9780743273565', 'Domestic', '823.91', 1),
('A Brief History of Time', 'Stephen Hawking', 'Bantam', '1988-04-01', '9780553380163', 'Foreign', '530.11', 2);

-- 도서 종류 테이블
CREATE TABLE BookGenre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(100) NOT NULL,
    CategoryCode VARCHAR(50),
    Description TEXT
);

INSERT INTO BookGenre (GenreName, CategoryCode, Description)
VALUES
('Fiction', '823', 'Literature & Fiction'),
('Science', '500', 'Scientific books'),
('History', '900', 'Historical books');


```

100. 주의사항
테이블 간의 데이터 삽입 순서를 지켜야 한다.
GeneralData -> companyData 및  PurchaseOrgMaster
BookGenre -> Book
101. 실행캡처
테이블 생성 및 삽입 후 결과를 MySQL 워크벤치나 CLI에서 실행 후 캡처하여 제출하세요:

SHOW TABLES;
DESCRIBE Book;
DESCRIBE BookGenre;
각 테이블의 SELECT 결과.


4. 데이터 검색(select)
```sql
--4. 데이터 검색(select)

-- 1. FROM 절에 2개의 릴레이션을 사용하는 질의 GeneralData와 PurchaseOrgMaster를 조인하여 고객명과 구매 조직 정보를 가져옵니다.
SELECT g.CustomerName, p.PurchaseOrg, p.PurchaseOrderCurrency
FROM GeneralData g
JOIN PurchaseOrgMaster p ON g.CustomerID = p.CustomerID;

-- 2. FROM 절에 3개의 릴레이션을 사용하는 질의 GeneralData, CompanyData, PurchaseOrgMaster를 조인하여 고객명, 회사 코드, 구매 그룹 정보를 가져옵니다.
SELECT g.CustomerName, c.CompanyCode, p.PurchaseGroup
FROM GeneralData g
JOIN CompanyData c ON g.CustomerID = c.CustomerID
JOIN PurchaseOrgMaster p ON g.CustomerID = p.CustomerID;

-- 3. FROM 절에 5개의 릴레이션을 사용하는 질의 GeneralData, CompanyData, PurchaseOrgMaster, Book, BookGenre를 조인하여 고객명, 구매 조직, 도서명, 장르 이름을 가져옵니다.
SELECT g.CustomerName, p.PurchaseOrg, b.Title, bg.GenreName
FROM GeneralData g
JOIN CompanyData c ON g.CustomerID = c.CustomerID
JOIN PurchaseOrgMaster p ON g.CustomerID = p.CustomerID
JOIN Book b ON b.GenreID = bg.GenreID
JOIN BookGenre bg ON b.GenreID = bg.GenreID;

-- 4. WHERE 절에 연산자를 사용한 서브쿼리
-- 4.1 IN 연산자를 사용하는 서브쿼리, BookGenre에서 장르가 'Fiction'인 책의 제목을 조회합니다.
SELECT Title
FROM Book
WHERE GenreID IN (
    SELECT GenreID
    FROM BookGenre
    WHERE GenreName = 'Fiction'
);

-- 4.2 EXISTS 연산자를 사용하는 서브쿼리, Book 테이블에 장르가 존재하는 책의 제목을 조회합니다.
SELECT Title
FROM Book b
WHERE EXISTS (
    SELECT *
    FROM BookGenre bg
    WHERE b.GenreID = bg.GenreID
);

-- 4.3 SOME 연산자를 사용하는 서브쿼리, 출판일이 가장 오래된 책의 출판사명을 조회합니다.
SELECT Publisher
FROM Book
WHERE PublicationDate = SOME (
    SELECT MIN(PublicationDate)
    FROM Book
);

-- 4.4 UNIQUE를 사용하는 서브쿼리, ISBN이 유일한 도서만 조회합니다.
SELECT Title, ISBN
FROM Book b
WHERE UNIQUE (
    SELECT ISBN
    FROM Book
    WHERE ISBN = b.ISBN
);

-- 5. 집합 연산자 사용 (INTERSECT, UNION, EXCEPT)
-- 5.1 INTERSECT 사용,ISBN이 존재하며, 장르가 'Science'인 도서를 조회합니다.
SELECT ISBN
FROM Book
WHERE ISBN IS NOT NULL
INTERSECT
SELECT ISBN
FROM Book b
JOIN BookGenre bg ON b.GenreID = bg.GenreID
WHERE bg.GenreName = 'Science';

-- 5.2 UNION 사용,모든 도서명과 모든 구매처명을 결합합니다
SELECT Title AS Name
FROM Book
UNION
SELECT CustomerName AS Name
FROM GeneralData;

-- 5.3 EXCEPT 사용,ISBN이 있는 책 중 장르가 'History'가 아닌 책을 조회합니다.
SELECT ISBN
FROM Book
EXCEPT
SELECT b.ISBN
FROM Book b
JOIN BookGenre bg ON b.GenreID = bg.GenreID
WHERE bg.GenreName = 'History';

MySQL은 EXCEPT 연산자를 기본적으로 지원하지 않습니다. 대신 NOT IN, LEFT JOIN, 또는 **NOT EXISTS**를 사용하여 동일한 결과를 얻을 수 있습니다.

