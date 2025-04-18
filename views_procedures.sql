USE InsuranceClaimsDB;
GO

-- View for high-risk policies (BonusMalus > 100)
CREATE VIEW v_HighRiskPolicies AS
SELECT * FROM InsuranceClaims
WHERE BonusMalus > 100;

-- Procedure to get claims summary per brand for a given region
CREATE PROCEDURE sp_BrandClaimsByRegion @Region VARCHAR(50)
AS
BEGIN
    SELECT VehBrand, SUM(ClaimNb) AS TotalClaims
    FROM InsuranceClaims
    WHERE Region = @Region
    GROUP BY VehBrand
    ORDER BY TotalClaims DESC;
END;

-- Example usage
EXEC sp_BrandClaimsByRegion 'Picardie';