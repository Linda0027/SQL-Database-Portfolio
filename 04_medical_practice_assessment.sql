-- ====================================================================
-- MODULE ASSESSMENTS: DBAS6211 PRACTICAL COMPUTER WORK
-- PROJECT: MEDICAL PRACTICE DATABASE SYSTEM ARCHITECTURE
-- AUTHOR:  Linda Mxolisi Nkosi (Student ID: st10130513)
-- PLATFORM: MySQL Server Workspace Environment
-- ====================================================================

-- Q.3.1 Create Parent Table: Patient
CREATE TABLE IF NOT EXISTS Patient (
    PatientID INT NOT NULL,
    PatientName VARCHAR(100) NOT NULL,
    PatientSurname VARCHAR(100) NOT NULL,
    PatientDOB DATE NOT NULL,
    PRIMARY KEY (PatientID)
);

-- Q.3.2 Create Parent Table: Doctor
CREATE TABLE IF NOT EXISTS Doctor (
    DoctorID INT NOT NULL,
    DoctorName VARCHAR(100) NOT NULL,
    DoctorSurname VARCHAR(100) NOT NULL,
    PRIMARY KEY (DoctorID)
);

-- Q.3.3 Create Child Table: Appointment with Foreign Key Constraints
CREATE TABLE IF NOT EXISTS Appointment (
    AppointmentID INT NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    AppointmentDuration INT NOT NULL,
    PRIMARY KEY (AppointmentID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

-- Q.3.5 Date Range Evaluation Query
SELECT * FROM Appointment
WHERE AppointmentDate BETWEEN '2024-01-16' AND '2024-01-20';

-- Q.3.6 Metrics Aggregation (Total Appointments Per Patient)
SELECT P.PatientName, P.PatientSurname, COUNT(A.AppointmentID) AS TotalAppointments
FROM Patient P
LEFT JOIN Appointment A ON P.PatientID = A.PatientID
GROUP BY P.PatientID, P.PatientName, P.PatientSurname
ORDER BY TotalAppointments DESC;

-- Q.3.7 Multi-Table Complex 3-Way Inner Join
SELECT A.AppointmentDate, A.AppointmentTime, D.DoctorName, D.DoctorSurname, P.PatientName, P.PatientSurname
FROM Appointment A
INNER JOIN Doctor D ON A.DoctorID = D.DoctorID
INNER JOIN Patient P ON A.PatientID = P.PatientID
ORDER BY A.AppointmentDate DESC;

-- Q.3.8 Database Structural View Instantiation
DROP VIEW IF EXISTS PatientDoctor2View;
CREATE VIEW PatientDoctor2View AS
SELECT DISTINCT P.PatientName, P.PatientSurname
FROM Patient P
INNER JOIN Appointment A ON P.PatientID = A.PatientID
WHERE A.DoctorID = 2
ORDER BY P.PatientSurname ASC;
