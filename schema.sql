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

-- Area Dimension (if you have this table, complete its columns)
CREATE TABLE DimArea (
    -- Define columns here
);

-- Indexes
CREATE INDEX idx_region ON InsuranceClaims(Region);
CREATE INDEX idx_vehbrand ON InsuranceClaims(VehBrand);