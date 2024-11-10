Here's a `README.md` file for the **gis_aggregate_management** project, outlining the setup instructions, project structure, usage, and testing steps:

---

# GIS Aggregate Management Project

A prototype database and Uncertainty Quantification (UQ) module for managing and analyzing Idaho's aggregate material sources for the Idaho 
Transportation Department (ITD). This project uses PostgreSQL with PostGIS for spatial data and Python for data population and UQ calculations.

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

- **PostgreSQL** with **PostGIS extension** installed.
- **Python** (version 3.6 or higher).
- Required Python libraries: `psycopg2` and `numpy`.

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
