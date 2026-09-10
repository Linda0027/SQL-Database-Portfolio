-- ====================================================================
-- PROJECT: ENTERPRISE TICKETING & CLIENT RELATIONSHIP ARCHITECTURE
-- PURPOSE: Relational Schema Mapping with Core Business Constraints
-- AUTHOR:  Linda Mxolisi Nkosi
-- ====================================================================

-- 1. Establish Master Clients Matrix Table
CREATE TABLE Core_Clients (
    ClientID INT IDENTITY(100,1) PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    ContactEmail VARCHAR(150) UNIQUE NOT NULL,
    ServiceLevelAgreement VARCHAR(20) DEFAULT 'Standard',
    DateRegistered DATE DEFAULT GETDATE(),
    CONSTRAINT CHK_SLA_Tier CHECK (ServiceLevelAgreement IN ('Standard', 'Premium', 'Enterprise'))
);

-- 2. Establish Master Infrastructure Asset Log
CREATE TABLE Infrastructure_Assets (
    AssetID INT IDENTITY(500,1) PRIMARY KEY,
    AssetName VARCHAR(100) NOT NULL,
    AssetType VARCHAR(50) NOT NULL,
    OperationalStatus VARCHAR(20) NOT NULL,
    IPAddress VARCHAR(15) UNIQUE NULL,
    CONSTRAINT CHK_Status CHECK (OperationalStatus IN ('Active', 'Maintenance', 'Decommissioned'))
);

-- 3. Establish Transactional Operational Incidents Ledger
CREATE TABLE System_Incidents (
    IncidentID INT IDENTITY(1000,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    AssetID INT NOT NULL,
    IncidentDescription TEXT NOT NULL,
    SeverityLevel VARCHAR(10) NOT NULL,
    ResolutionStatus VARCHAR(15) DEFAULT 'Open',
    LoggedTimestamp DATETIME DEFAULT GETDATE(),
    -- Enforce Relational Integrity via Constraints
    CONSTRAINT FK_Incident_Client FOREIGN KEY (ClientID) 
        REFERENCES Core_Clients(ClientID) ON DELETE CASCADE,
    CONSTRAINT FK_Incident_Asset FOREIGN KEY (AssetID) 
        REFERENCES Infrastructure_Assets(AssetID),
    CONSTRAINT CHK_Severity CHECK (SeverityLevel IN ('Low', 'Medium', 'High', 'Critical'))
);

-- 4. Inject Mock Data Sets for Operations Validation
INSERT INTO Core_Clients (CompanyName, ContactEmail, ServiceLevelAgreement) VALUES 
('Gauteng Tech Solutions', 'info@gautengtech.co.za', 'Enterprise'),
('Tshwane Retail Hub', 'operations@tshwaneretail.com', 'Standard'),
('KwaMhlanga Logistics', 'fleet@kwamhlangalog.co.za', 'Premium');

INSERT INTO Infrastructure_Assets (AssetName, AssetType, OperationalStatus, IPAddress) VALUES 
('Main Database Server Cluster', 'Database Server', 'Active', '192.168.10.25'),
('Core Branch Edge Router', 'Networking Device', 'Active', '192.168.10.1'),
('Legacy Application Virtual Machine', 'VM Instance', 'Maintenance', '10.0.0.55');

INSERT INTO System_Incidents (ClientID, AssetID, IncidentDescription, SeverityLevel, ResolutionStatus) VALUES 
(100, 500, 'High latency detected during concurrent write transactions.', 'High', 'Open'),
(102, 501, 'Interface timeout on physical uplink connection interface.', 'Critical', 'Open'),
(101, 500, 'User connection failure matching standard query criteria.', 'Medium', 'Resolved');
