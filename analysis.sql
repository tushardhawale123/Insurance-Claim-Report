USE InsuranceClaimsDB;
GO

-- Total records
SELECT COUNT(*) FROM InsuranceClaims;

-- Preview data
SELECT TOP 10 * FROM InsuranceClaims;

-- Total claims per region
SELECT Region, SUM(ClaimNb) AS TotalClaims
FROM InsuranceClaims
GROUP BY Region
ORDER BY TotalClaims DESC;

-- Average claim count by vehicle brand
SELECT VehBrand, AVG(ClaimNb) AS AvgClaims
FROM InsuranceClaims
GROUP BY VehBrand
ORDER BY AvgClaims DESC;

-- Distribution of fuel types
SELECT VehGas, COUNT(*) AS NumPolicies
FROM InsuranceClaims
GROUP BY VehGas;

-- Average driver age by area
SELECT Area, AVG(DrivAge) AS AvgDrivAge
FROM InsuranceClaims
GROUP BY Area;

-- Rank regions by total claims
SELECT Region, SUM(ClaimNb) AS TotalClaims,
       RANK() OVER (ORDER BY SUM(ClaimNb) DESC) AS ClaimRank
FROM InsuranceClaims
GROUP BY Region;