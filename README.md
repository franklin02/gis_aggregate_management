`README.md` file for the **gis_aggregate_management** project, outlining the setup instructions, project structure, usage, and testing steps:

---

# GIS Aggregate Management Project

This is a prototype database and Uncertainty Quantification (UQ) module for managing and analyzing Idaho's aggregate material sources for the State of Idaho
Public Transportation Infrastructure Construction use. The project provides tools for managing and analyzing aggregate material data using PostgreSQL and 
PostGIS. The project includes automated Uncertainty Quantification (UQ) metrics updates, data population scripts, and export functionality for 
integration with ArcGIS.

GIS Aggregate Management Project Developer: Dr. Yang Lu (P.E.) Associate Professor of Civil Engineering at Boise State University. Dr. Lu's expertise lies in 
infrastructure material database management, material quality control, material durability solutions, uncertainty quantification, and pavement evaluation. 
He has extensive experience in assessing performance measures for transportation infrastructure materials using advanced testing methods.

Copyright © 2024 Dr. Yang Lu. This software and accompanying documentation are licensed under the MIT License. All rights reserved. 
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the conditions of the MIT License are met.
For any inquiries or collaborations, please contact Dr. Yang Lu through Boise State University.


## Project Structure

```plaintext
gis_aggregate_management/
├── data/                            # Directory for sample data files
│   ├── source_data.csv              # Sample data file for aggregate sources
│   ├── material_quality.csv         # Sample data file for material quality
│   ├── environmental_compliance.csv # Sample data file for compliance data
│   └── operational_info.csv         # Sample data file for operational details
├── sql/                             # SQL scripts for database creation and setup
│   ├── create_tables.sql            # SQL script to create tables and define schema
│   ├── automate_uq_updates.sql      # SQL script to create UQ update function and trigger
│   ├── create_functions.sql         # SQL script for additional functions
│   └── insert_sample_data.sql       # Optional SQL script to insert initial sample data
├── scripts/                         # Python scripts for database population and UQ functions
│   ├── data_population.py           # Python script for loading data into PostgreSQL
│   ├── database_connection.py       # Python script for database connection handling
│   ├── export_data_for_arcgis.py    # Python script to export data for ArcGIS
│   ├── export_data_to_csv.py        # Python script to export data to CSV
│   ├── test_script.py               # Python test script for functionality checks
│   ├── testing_queries.py           # Python script to test database queries
│   ├── uncertainty_model.py         # Python script for UQ calculations
│   └── visualize_and_detect_outliers.py # Python script for visualizing data and detecting outliers
└── README.md                        # Instructions and project overview
```

## Prerequisites

- **PostgreSQL** with **PostGIS** extension installed.
- **Python** (version 3.6 or higher) with required libraries.
- **ArcGIS Online or ArcGIS Pro** (optional, for visualizing exported data).

### Install Required Python Libraries

Install the necessary libraries in your environment:

```bash
pip install psycopg2-binary numpy pandas matplotlib
```

## Database Setup

### 1. Create the Database

1. **Open pgAdmin** or use the PostgreSQL command line.
2. **Create the Database**:
   - Run the following command in SQL or pgAdmin to create the database:

     ```sql
     CREATE DATABASE gis_aggregate_db;
     ```

3. **Enable PostGIS Extension**:
   - Open the new database and enable PostGIS by running:

     ```sql
     CREATE EXTENSION postgis;
     ```

### 2. Run the `create_tables.sql` Script

1. **Open `create_tables.sql`** in pgAdmin’s Query Tool.
2. **Execute the Script**:
   - This will create the required tables, including `Source`, `Material_Quality`, `Environmental_Compliance`, `Operational_Info`, `UQ_Results`, and any additional tables specified.

### 3. Set Up Automated UQ Updates

1. **Run `automate_uq_updates.sql`**:
   - Open `automate_uq_updates.sql` in the Query Tool.
   - Execute it to create the function `update_uq_metrics` and the trigger `recalculate_uq_after_insert`.
   - This trigger will automatically update the `UQ_Results` table whenever data is inserted or updated in `Material_Quality`.

## Data Population

1. **Update `source_data.csv`, `material_quality.csv`, `environmental_compliance.csv`, and `operational_info.csv`** with your project data as needed.
2. **Run `data_population.py`** to populate the database with initial data:

   ```bash
   python scripts/data_population.py
   ```

3. **Verify the Data in pgAdmin**:
   - Check that all tables (`Source`, `Material_Quality`, etc.) have been populated as expected.

## Testing and Using UQ Calculations

1. **Run `uncertainty_model.py`** to calculate UQ metrics:

   ```bash
   python scripts/uncertainty_model.py
   ```

   - This script will calculate and store UQ metrics (mean, standard deviation, reliability index) for each `Source_ID` in `UQ_Results`.

2. **Verify the Results in pgAdmin**:
   - Open `UQ_Results` and confirm that UQ metrics are calculated and stored for each source.

## Export Data for ArcGIS

1. **Run `export_data_for_arcgis.py`** to export data with UQ metrics to a CSV file:

   ```bash
   python scripts/export_data_for_arcgis.py
   ```

2. **Upload to ArcGIS**:
   - Log into ArcGIS Online or ArcGIS Pro and upload the generated CSV (`data_with_uq_for_arcgis.csv`).
   - Publish as a hosted layer and create a map for visualization and analysis.

## Visualization and Outlier Detection

1. **Run `visualize_and_detect_outliers.py`** to visualize the distribution of data and identify outliers:

   ```bash
   python scripts/visualize_and_detect_outliers.py
   ```

2. **Interpret Results**:
   - View the generated plots and review outlier detection output.

## ArcGIS Online Map for Idaho Aggregate Source Data

As part of the project’s GIS integration, we have created an **Idaho Aggregate Source Management Map** using the data with calculated UQ metrics. 
This map is available on **ArcGIS Online** and allows for public access to view data on aggregate source locations, material quality, and reliability metrics.
The ArcGIS Online map for Idaho aggregate source data provides users with a visual tool to explore material quality geographically.

**Map Features**:
- **Geographic Visualization**: Each source is represented as a point on the map, showing its geographic location within Idaho.
- **Pop-up Details**: Clicking on each point reveals detailed information, including `Mean_Value`, `Reliability_Index`, `Standard_Deviation`, and other key metrics for material quality.
- **Layer Customization**: Users can adjust map layers and symbology to analyze material quality across different regions, supporting location-based sourcing decisions.

**Link to Public Map**:
- [Idaho Aggregate Source Management Map on ArcGIS Online](https://www.arcgis.com/apps/mapviewer/index.html?webmap=8474eed4594e42a5a8ece354c0defacc)*

---

## Additional Information

- **Uncertainty Quantification (UQ) Functions**:
  - The UQ functions calculate mean, standard deviation, and reliability index for material quality test values. The reliability index gives 
  an initial measure of material reliability, which is useful for planning and quality assurance.
- **Triggers**:
  - Triggers automatically update UQ metrics when new data is inserted or existing data is updated in the `Material_Quality` table.

## Troubleshooting

- **Database Connection Issues**:
  - Ensure PostgreSQL is running, and verify that credentials in `database_connection.py` are correct.
- **Data Insertion Errors**:
  - Confirm that CSV files have the correct structure and that columns align with the database schema.
- **PostGIS Issues**:
  - Verify PostGIS is installed and enabled with `CREATE EXTENSION postgis;`.

## Future Steps

- **Integrate with ArcGIS**: After testing, the database can be connected to ArcGIS for spatial analysis and visualization.
- **Extend UQ Models**: Develop additional UQ models, such as Bayesian updating, to continuously calibrate metrics with new data.

---
