-- ====================================================================
-- PROJECT: ENTERPRISE TICKETING & CLIENT RELATIONSHIP ARCHITECTURE
-- PURPOSE: Advanced Analytical Operations (JOINs, Aggregations, Subqueries)
-- AUTHOR:  Linda Mxolisi Nkosi
-- ====================================================================

-- QUERY 1: Multi-Table Operational Reconciliation (3-Way Inner Join)
SELECT 
    I.IncidentID,
    C.CompanyName,
    C.ServiceLevelAgreement AS SLA_Tier,
    A.AssetName,
    A.IPAddress,
    I.SeverityLevel,
    I.ResolutionStatus,
    FORMAT(I.LoggedTimestamp, 'yyyy-MM-dd HH:mm') AS FormattedLogTime
FROM System_Incidents I
INNER JOIN Core_Clients C ON I.ClientID = C.ClientID
INNER JOIN Infrastructure_Assets A ON I.AssetID = A.AssetID
WHERE I.ResolutionStatus = 'Open'
ORDER BY 
    CASE I.SeverityLevel 
        WHEN 'Critical' THEN 1 
        WHEN 'High' THEN 2 
        WHEN 'Medium' THEN 3 
        ELSE 4 
    END;

-- QUERY 2: Granular Performance Metrics Aggregation
SELECT 
    A.AssetType,
    COUNT(I.IncidentID) AS TotalLoggedIncidents,
    SUM(CASE WHEN I.ResolutionStatus = 'Open' THEN 1 ELSE 0 END) AS OpenIncidentsCount,
    SUM(CASE WHEN I.ResolutionStatus = 'Resolved' THEN 1 ELSE 0 END) AS ResolvedIncidentsCount
FROM Infrastructure_Assets A
LEFT JOIN System_Incidents I ON A.AssetID = I.AssetID
GROUP BY A.AssetType;

-- QUERY 3: Advanced Conditional Filtering via Correlated Subquery
SELECT 
    ClientID,
    CompanyName,
    ContactEmail,
    ServiceLevelAgreement
FROM Core_Clients C
WHERE (
    SELECT COUNT(*) 
    FROM System_Incidents I 
    WHERE I.ClientID = C.ClientID
) > (
    SELECT AVG(IncidentCount) 
    FROM (
        SELECT COUNT(*) AS IncidentCount 
        FROM System_Incidents 
        GROUP BY ClientID
    ) AS AverageSubtable
);
