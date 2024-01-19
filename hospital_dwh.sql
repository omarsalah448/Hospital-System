drop schema if exists team1_dwh;
create database If not exists team1_dwh;
use team1_dwh;

CREATE TABLE dim_date (
    DateTimeKey INT PRIMARY KEY,
    FullDateTime DATETIME,
    Year INT,
    Quarter INT,
    Month INT,
    DayOfMonth INT,
    DayOfWeek INT,
    DayOfYear INT,
    WeekOfYear INT,
    Period CHAR(2) CHECK (Period IN ('AM', 'PM'))
);

CREATE TABLE dim_doctor (
    SK_Doctor BIGINT AUTO_INCREMENT KEY,
    SSN BIGINT,
    Email VARCHAR(100),
    Specialization VARCHAR(50),
    AppointmentPrice INT,
    Follow_Up INT,
    Salary INT,
    Shift VARCHAR(2) CHECK (Shift IN ('AM', 'PM')),
    Department_name VARCHAR(100),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);

CREATE TABLE dim_nurse (
    SK_Nurse BIGINT AUTO_INCREMENT PRIMARY KEY,
    SSN BIGINT,
    Email VARCHAR(100),
    Qualification VARCHAR(50),
    Shift VARCHAR(2) CHECK (Shift IN ('AM', 'PM')),
    department_name VARCHAR(100),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);

CREATE TABLE dim_patient (
    SK_Patient BIGINT AUTO_INCREMENT PRIMARY KEY,
    SSN INT(11),
    Email VARCHAR(100),
    BloodType VARCHAR(3) CHECK (BloodType IN ('A', 'B', 'AB', 'O', 'A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-')),
    History VARCHAR(200),
    EmergencyContact VARCHAR(100),
    PatientType VARCHAR(11) CHECK (PatientType IN ('Inpatient', 'Outpatient')),
    CompanyName VARCHAR(100),
    DiscountPercent INT,
    Address VARCHAR(100),
    Country VARCHAR(100),
    city VARCHAR(100),
    insurance_pay Float(20,2),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);

CREATE TABLE dim_hospital (
    SK_Hospital BIGINT AUTO_INCREMENT PRIMARY KEY,
    HospitalID VARCHAR(16),
    Name VARCHAR(100),
    Country VARCHAR(50),
    City VARCHAR(50),
    Address VARCHAR(100),
    Phone INT(13),
    ManagerName VARCHAR(100),
    ManagerSSN BIGINT,
    ManagerDepartmentName VARCHAR(100),
    Capacity INT,
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);

CREATE TABLE dim_room (
    SK_Room BIGINT AUTO_INCREMENT PRIMARY KEY,
    RoomID VARCHAR(16) ,
    RoomNumber VARCHAR(20),
    ClassName VARCHAR(50),
    NumberOfBeds INT,
    Amenities VARCHAR(200),
    Price Float(10,2),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);



CREATE TABLE dim_administrative (
    SK_Administrative BIGINT AUTO_INCREMENT PRIMARY KEY,
    SSN BIGINT,
    Salary DECIMAL(10, 2),
    DepartmentName VARCHAR(100),
    SK_Hospital BIGINT,
    Email VARCHAR(255),
    JobTitle VARCHAR(50),
    FOREIGN KEY (SK_Hospital) REFERENCES dim_hospital (SK_Hospital),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);

CREATE TABLE fact_appointments (
    BK_Appointment BIGINT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID VARCHAR(16),
    SK_Doctor BIGINT,
    SK_Nurse BIGINT,
    DateTimeKey INT,
    SK_Patient BIGINT,
    AppointmentPrice DECIMAL(10, 2),
    Attended BIT,
    SK_Hospital BIGINT,
    FollowupPrice INT,
    FOREIGN KEY (SK_Doctor) REFERENCES dim_doctor (SK_Doctor),
    FOREIGN KEY (SK_Hospital) REFERENCES dim_hospital (SK_Hospital),
    FOREIGN KEY (SK_Nurse) REFERENCES dim_nurse (SK_Nurse),
    FOREIGN KEY (DateTimeKey) REFERENCES dim_date (DateTimeKey),
    FOREIGN KEY (SK_Patient) REFERENCES dim_patient (SK_Patient),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);

CREATE TABLE fact_room_reservations (
    BK_Reservation BIGINT AUTO_INCREMENT PRIMARY KEY,
    SK_Patient BIGINT,
    SK_Room BIGINT,
    CheckinDate INT,
    CheckoutDate INT,
    SK_Nurse BIGINT,
    FOREIGN KEY (SK_Patient) REFERENCES dim_patient (SK_Patient),
    FOREIGN KEY (CheckinDate) REFERENCES dim_date (DateTimeKey),
    FOREIGN KEY (CheckoutDate) REFERENCES dim_date (DateTimeKey),
    FOREIGN KEY (SK_Room) REFERENCES dim_room (SK_Room),
    FOREIGN KEY (SK_Nurse) REFERENCES dim_nurse (SK_Nurse),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);


CREATE TABLE fact_bill (
    BK_Bill BIGINT AUTO_INCREMENT PRIMARY KEY,
    BillID varchar(16),
    SK_Hospital BIGINT,
    SK_Patient BIGINT,
    DateTimeKey INT,
    PaymentAmount DECIMAL(10, 2),
    PaymentDate INT,
    FOREIGN KEY (SK_Hospital) REFERENCES dim_hospital (SK_Hospital),
    FOREIGN KEY (SK_Patient) REFERENCES dim_patient (SK_Patient),
    FOREIGN KEY (DateTimeKey) REFERENCES dim_date (DateTimeKey),
    FOREIGN KEY (PaymentDate) REFERENCES dim_date (DateTimeKey),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);

CREATE TABLE fact_expense (
    BK_Expense BIGINT AUTO_INCREMENT PRIMARY KEY,
    ExpenseID INT,
    SK_Hospital BIGINT,
    ExpenseType VARCHAR(50),
    Amount INT,
    PaymentDate INT,
    FOREIGN KEY (SK_Hospital) REFERENCES dim_hospital (SK_Hospital),
    FOREIGN KEY (PaymentDate) REFERENCES dim_date (DateTimeKey),
    Hash_value VARCHAR(255),
    Latest_value BIT,
    Deleted BIT,
    DWH_entry_date DATETIME
);
