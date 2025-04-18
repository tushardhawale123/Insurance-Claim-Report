CREATE DATABASE InsuranceClaimsDB;
GO

USE InsuranceClaimsDB;
GO

CREATE TABLE InsuranceClaims (
    id INT PRIMARY KEY,
    IDpol VARCHAR(50),           -- Policy identifier
    ClaimNb INT,                 -- Number of claims
    Exposure FLOAT,              -- Risk exposure
    Area VARCHAR(20),            -- Area code/category
    VehPower INT,                -- Vehicle power
    VehAge INT,                  -- Vehicle age
    DrivAge INT,                 -- Driver age
    BonusMalus INT,              -- Bonus/Malus score (risk adjustment)
    VehBrand VARCHAR(50),        -- Vehicle brand
    VehGas VARCHAR(10),          -- Fuel type
    Density FLOAT,               -- Regional density
    Region VARCHAR(50)           -- Region name/code
);

-- Total records
SELECT COUNT(*) FROM InsuranceClaims;

-- Preview data
SELECT TOP 10 * FROM InsuranceClaims;

-- Check for NULLs
SELECT 
    SUM(CASE WHEN ClaimNb IS NULL THEN 1 ELSE 0 END) AS NullClaimNb,
    SUM(CASE WHEN Exposure IS NULL THEN 1 ELSE 0 END) AS NullExposure,
    SUM(CASE WHEN VehPower IS NULL THEN 1 ELSE 0 END) AS NullVehPower
FROM InsuranceClaims;

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

-- Create a view for high-risk policies (BonusMalus > 100)
CREATE VIEW v_HighRiskPolicies AS
SELECT * FROM InsuranceClaims
WHERE BonusMalus > 100;

-- Index for frequent queries
CREATE INDEX idx_region ON InsuranceClaims(Region);
CREATE INDEX idx_vehbrand ON InsuranceClaims(VehBrand);

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

EXEC sp_BrandClaimsByRegion 'Picardie';


-- Area Dimension
CREATE TABLE DimArea (
    AreaKey INT IDENTITY(1,1) PRIMARY KEY,
    Area VARCHAR(20) UNIQUE
);

-- Vehicle Dimension
CREATE TABLE DimVehicle (
    VehicleKey INT IDENTITY(1,1) PRIMARY KEY,
    VehPower INT,
    VehAge INT
);

-- Driver Dimension
CREATE TABLE DimDriver (
    DriverKey INT IDENTITY(1,1) PRIMARY KEY,
    DrivAge INT
);

-- Policy Dimension
CREATE TABLE DimPolicy (
    PolicyKey INT IDENTITY(1,1) PRIMARY KEY,
    IDpol VARCHAR(50) UNIQUE,
    BonusMalus INT,
    Exposure FLOAT
);

-- Brand Dimension
CREATE TABLE DimBrand (
    BrandKey INT IDENTITY(1,1) PRIMARY KEY,
    VehBrand VARCHAR(50) UNIQUE
);

-- Fuel Type Dimension
CREATE TABLE DimFuel (
    FuelKey INT IDENTITY(1,1) PRIMARY KEY,
    VehGas VARCHAR(10) UNIQUE
);

-- Region Dimension
CREATE TABLE DimRegion (
    RegionKey INT IDENTITY(1,1) PRIMARY KEY,
    Region VARCHAR(50) UNIQUE
);


-- Area
INSERT INTO DimArea (Area)
SELECT DISTINCT Area FROM InsuranceClaims WHERE Area IS NOT NULL;

-- Vehicle
INSERT INTO DimVehicle (VehPower, VehAge)
SELECT DISTINCT VehPower, VehAge FROM InsuranceClaims;

-- Driver
INSERT INTO DimDriver (DrivAge)
SELECT DISTINCT DrivAge FROM InsuranceClaims;

-- Policy
INSERT INTO DimPolicy (IDpol, BonusMalus, Exposure)
SELECT DISTINCT IDpol, BonusMalus, Exposure FROM InsuranceClaims;

-- Brand
INSERT INTO DimBrand (VehBrand)
SELECT DISTINCT VehBrand FROM InsuranceClaims WHERE VehBrand IS NOT NULL;

-- Fuel
INSERT INTO DimFuel (VehGas)
SELECT DISTINCT VehGas FROM InsuranceClaims WHERE VehGas IS NOT NULL;

-- Region
INSERT INTO DimRegion (Region)
SELECT DISTINCT Region FROM InsuranceClaims WHERE Region IS NOT NULL;

-- Fact Table
CREATE TABLE FactClaims (
    FactID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyKey INT,
    AreaKey INT,
    VehicleKey INT,
    DriverKey INT,
    BrandKey INT,
    FuelKey INT,
    RegionKey INT,
    ClaimNb INT,
    FOREIGN KEY (PolicyKey) REFERENCES DimPolicy(PolicyKey),
    FOREIGN KEY (AreaKey) REFERENCES DimArea(AreaKey),
    FOREIGN KEY (VehicleKey) REFERENCES DimVehicle(VehicleKey),
    FOREIGN KEY (DriverKey) REFERENCES DimDriver(DriverKey),
    FOREIGN KEY (BrandKey) REFERENCES DimBrand(BrandKey),
    FOREIGN KEY (FuelKey) REFERENCES DimFuel(FuelKey),
    FOREIGN KEY (RegionKey) REFERENCES DimRegion(RegionKey)
);

INSERT INTO FactClaims (
    PolicyKey, AreaKey, VehicleKey, DriverKey, BrandKey, FuelKey, RegionKey, ClaimNb
)
SELECT 
    p.PolicyKey,
    a.AreaKey,
    v.VehicleKey,
    d.DriverKey,
    b.BrandKey,
    f.FuelKey,
    r.RegionKey,
    ic.ClaimNb
FROM InsuranceClaims ic
JOIN DimPolicy p ON ic.IDpol = p.IDpol
JOIN DimArea a ON ic.Area = a.Area
JOIN DimVehicle v ON ic.VehPower = v.VehPower AND ic.VehAge = v.VehAge
JOIN DimDriver d ON ic.DrivAge = d.DrivAge
JOIN DimBrand b ON ic.VehBrand = b.VehBrand
JOIN DimFuel f ON ic.VehGas = f.VehGas
JOIN DimRegion r ON ic.Region = r.Region;

-- Total Claims by Region and Vehicle Brand
SELECT
    dr.Region,
    db.VehBrand,
    SUM(fc.ClaimNb) AS TotalClaims
FROM FactClaims fc
JOIN DimRegion dr ON fc.RegionKey = dr.RegionKey
JOIN DimBrand db ON fc.BrandKey = db.BrandKey
GROUP BY dr.Region, db.VehBrand
ORDER BY TotalClaims DESC;

CREATE VIEW vw_ClaimsByRegionBrand AS
SELECT 
    dr.Region, 
    db.VehBrand, 
    SUM(f.ClaimNb) AS TotalClaims
FROM FactClaims f
JOIN DimRegion dr ON f.RegionKey = dr.RegionKey
JOIN DimBrand db ON f.BrandKey = db.BrandKey
GROUP BY dr.Region, db.VehBrand;

