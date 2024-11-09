-- Enable PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;

-- Create Source Table
CREATE TABLE IF NOT EXISTS Source (
    Source_ID VARCHAR(10) PRIMARY KEY,
    Source_Name VARCHAR(50),
    Latitude DECIMAL(9, 6),
    Longitude DECIMAL(9, 6),
    District_Region VARCHAR(20),
    Status VARCHAR(20),
    Aggregate_Type VARCHAR(20)
);

-- Create Material_Quality Table
CREATE TABLE IF NOT EXISTS Material_Quality (
    Material_ID VARCHAR(10) PRIMARY KEY,
    Source_ID VARCHAR(10) REFERENCES Source(Source_ID),
    Aggregate_Use VARCHAR(50),
    Lab_Test_Type VARCHAR(50),
    Test_Value DECIMAL(5, 2),
    Test_Date DATE,
    Data_Source VARCHAR(50)
);

-- Create Environmental_Compliance Table
CREATE TABLE IF NOT EXISTS Environmental_Compliance (
    Compliance_ID VARCHAR(10) PRIMARY KEY,
    Source_ID VARCHAR(10) REFERENCES Source(Source_ID),
    Cultural_Clearance BOOLEAN,
    Environmental_Permits VARCHAR(50),
    Reclamation_Plan VARCHAR(100)
);

-- Create Operational_Info Table
CREATE TABLE IF NOT EXISTS Operational_Info (
    Operation_ID VARCHAR(10) PRIMARY KEY,
    Source_ID VARCHAR(10) REFERENCES Source(Source_ID),
    Ownership_Details VARCHAR(100),
    Lease_Information VARCHAR(50),
    Extraction_Method VARCHAR(50),
    Access_Details VARCHAR(100)
);

-- Create Mapping_Imagery Table (optional for future spatial layers)
CREATE TABLE IF NOT EXISTS Mapping_Imagery (
    Map_ID SERIAL PRIMARY KEY,
    Source_ID VARCHAR(10) REFERENCES Source(Source_ID),
    Map_File VARCHAR(255),
    Plat_Diagram VARCHAR(255),
    Imagery_File VARCHAR(255),
    Spatial_Location GEOMETRY(Point, 4326) -- spatial geometry for location mapping
);

-- Create UQ_Results Table
CREATE TABLE IF NOT EXISTS UQ_Results (
    Metric_ID SERIAL PRIMARY KEY,
    Source_ID VARCHAR(10) REFERENCES Source(Source_ID),
    Mean_Value DECIMAL(10, 4),
    Standard_Deviation DECIMAL(10, 4),
    Reliability_Index DECIMAL(10, 4),
    Calculation_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
