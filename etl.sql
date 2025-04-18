USE InsuranceClaimsDB;
GO

-- Remove duplicates (if any)
WITH Duplicates AS (
    SELECT id, COUNT(*) AS cnt
    FROM InsuranceClaims
    GROUP BY id
    HAVING COUNT(*) > 1
)
DELETE FROM InsuranceClaims WHERE id IN (SELECT id FROM Duplicates);

-- Standardize Area (example: uppercase all)
UPDATE InsuranceClaims SET Area = UPPER(Area);

-- Handle missing (null) values, e.g., set default for Exposure
UPDATE InsuranceClaims SET Exposure = 1 WHERE Exposure IS NULL;

-- Check for outliers (e.g., negative ages)
SELECT * FROM InsuranceClaims WHERE DrivAge < 16 OR VehAge < 0;

-- Check for NULLs
SELECT 
    SUM(CASE WHEN ClaimNb IS NULL THEN 1 ELSE 0 END) AS NullClaimNb,
    SUM(CASE WHEN Exposure IS NULL THEN 1 ELSE 0 END) AS NullExposure,
    SUM(CASE WHEN VehPower IS NULL THEN 1 ELSE 0 END) AS NullVehPower
FROM InsuranceClaims;