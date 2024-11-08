-- Insert data into Source Table
INSERT INTO Source (Source_ID, Source_Name, Latitude, Longitude, District_Region, Status, Aggregate_Type)
VALUES 
('S001', 'Pine Quarry', 44.1234, -115.1234, 'District 1', 'Active', 'Gravel'),
('S002', 'Bear Rock Site', 43.5678, -116.5678, 'District 2', 'Depleted', 'Sand'),
('S003', 'Elk Gravel Pit', 44.8765, -114.8765, 'District 1', 'Retired', 'Rock');

-- Insert data into Material Quality Table
INSERT INTO Material_Quality (Material_ID, Source_ID, Aggregate_Use, Lab_Test_Type, Test_Value, Test_Date, Data_Source)
VALUES
('M001', 'S001', 'Road Base', 'Abrasion', 23, '2024-01-01', 'Lab A'),
('M002', 'S002', 'Concrete Mix', 'Gradation', 8, '2023-12-15', 'Lab B'),
('M003', 'S003', 'Pavement Fill', 'Specific Gravity', 2.65, '2024-01-10', 'Lab C');

-- Insert data into Environmental Compliance Table
INSERT INTO Environmental_Compliance (Compliance_ID, Source_ID, Cultural_Clearance, Environmental_Permits, Reclamation_Plan)
VALUES
('E001', 'S001', true, 'Permit-123', 'Reclamation Plan A'),
('E002', 'S002', false, 'Permit-456', 'Reclamation Plan B'),
('E003', 'S003', true, 'Permit-789', 'Reclamation Plan C');

-- Insert data into Operational Info Table
INSERT INTO Operational_Info (Operation_ID, Source_ID, Ownership_Details, Lease_Information, Extraction_Method, Access_Details)
VALUES
('O001', 'S001', 'Idaho Gravel Co.', 'Lease A', 'Surface Mining', '5 miles from Highway 55'),
('O002', 'S002', 'Sand & Rock Partners', 'Lease B', 'Underground', '10 miles from Highway 21'),
('O003', 'S003', 'Elk Valley Resources', 'Lease C', 'Surface Mining', '8 miles from Interstate 84');
