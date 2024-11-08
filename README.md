Here's a `README.md` file for the **gis_aggregate_management** project, outlining the setup instructions, project structure, usage, and testing steps:

---

# GIS Aggregate Management Project

A prototype database and Uncertainty Quantification (UQ) module for managing and analyzing Idaho's aggregate material sources for the Idaho 
Transportation Department (ITD). This project uses PostgreSQL with PostGIS for spatial data and Python for data population and UQ calculations.

## Project Structure

```plaintext
gis_aggregate_management/
├── data/                        # Directory for sample data files
│   ├── source_data.csv          # Sample data file for aggregate sources
│   ├── material_quality.csv     # Sample data file for material quality
│   ├── environmental_compliance.csv # Sample data file for compliance data
│   └── operational_info.csv     # Sample data file for operational details
├── sql/                         # SQL scripts for database creation and setup
│   ├── create_tables.sql        # SQL script to create tables and define schema
│   ├── insert_sample_data.sql   # SQL script to insert sample data
│   └── create_functions.sql     # SQL script for database functions and triggers
├── scripts/                     # Python scripts for database population and UQ functions
│   ├── database_connection.py   # Python script to connect to PostgreSQL database
│   ├── data_population.py       # Python script for loading data into PostgreSQL
│   ├── uncertainty_model.py     # Python script for UQ modeling functions
│   └── testing_queries.py       # Python script for testing database and UQ queries
└── README.md                    # Instructions and project overview
```

## Prerequisites

- **PostgreSQL** with **PostGIS extension** installed.
- **Python** (version 3.6 or higher).
- Required Python libraries: `psycopg2` and `numpy`.

### Install Python Dependencies

```bash
pip install psycopg2 numpy
```

## Setting Up the Database

1. **Create the Database**:
   - Open PostgreSQL CLI or use a tool like pgAdmin.
   - Run the following command to create the database and enable PostGIS:

     ```sql
     CREATE DATABASE gis_aggregate_db;
     \c gis_aggregate_db;
     CREATE EXTENSION postgis;
     ```

2. **Create Tables**:
   - Run the SQL script `create_tables.sql` to create the tables and set up the database schema:

     ```sql
     \i sql/create_tables.sql
     ```

3. **Insert Sample Data**:
   - Run `insert_sample_data.sql` to populate the tables with sample data:

     ```sql
     \i sql/insert_sample_data.sql
     ```

4. **Load Functions and Triggers**:
   - Run `create_functions.sql` to create database functions and triggers for Uncertainty Quantification (UQ):

     ```sql
     \i sql/create_functions.sql
     ```

## Usage

### 1. Database Connection

Update `database_connection.py` with your PostgreSQL credentials:

```python
conn = psycopg2.connect(
    dbname="gis_aggregate_db",
    user="your_username",
    password="your_password",
    host="localhost",
    port="5432"
)
```

### 2. Populate Database from CSV Files

Run `data_population.py` to load sample data from the CSV files located in the `data/` directory:

```bash
python scripts/data_population.py
```

### 3. Run UQ Calculations

Run `uncertainty_model.py` to calculate basic UQ metrics such as mean, standard deviation, and reliability index for test values in the `Material_Quality` table:

```bash
python scripts/uncertainty_model.py
```

### 4. Testing Queries

Use `testing_queries.py` to verify that data has been loaded correctly and UQ functions are working as expected:

```bash
python scripts/testing_queries.py
```

## Testing the UQ Module

1. **Manual Testing in PostgreSQL**:
   - Run the following queries to test UQ functions created in `create_functions.sql`:

     ```sql
     SELECT calculate_mean_test_value('S001');
     SELECT calculate_stddev_test_value('S001');
     SELECT calculate_reliability_index('S001');
     ```

2. **Trigger Functionality**:
   - Insert a new record in `Material_Quality` to verify that triggers update the reliability index automatically:

     ```sql
     INSERT INTO Material_Quality (Material_ID, Source_ID, Aggregate_Use, Lab_Test_Type, Test_Value, Test_Date, Data_Source)
     VALUES ('M004', 'S001', 'Road Base', 'Abrasion', 25, '2024-02-01', 'Lab D');
     
     SELECT * FROM display_uq_metrics('S001');
     ```

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
