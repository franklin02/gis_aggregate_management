import csv
from database_connection import connect_to_db, close_db

def export_data_to_csv():
    conn, cursor = connect_to_db()
    if not conn:
        return

    try:
        # Fetch data from Source and UQ_Results tables
        query = """
        SELECT s.source_id, s.source_name, s.latitude, s.longitude, u.mean_value, u.standard_deviation, u.reliability_index
        FROM Source s
        JOIN UQ_Results u ON s.source_id = u.source_id;
        """
        cursor.execute(query)
        rows = cursor.fetchall()

        # Define CSV filename
        csv_file = "exported_data_with_uq.csv"

        # Write data to CSV
        with open(csv_file, mode='w', newline='') as file:
            writer = csv.writer(file)
            # Write headers
            writer.writerow(['Source_ID', 'Source_Name', 'Latitude', 'Longitude', 'Mean_Value', 'Standard_Deviation', 'Reliability_Index'])
            # Write data rows
            for row in rows:
                writer.writerow(row.values())

        print(f"Data successfully exported to {csv_file}")

    except Exception as e:
        print("Error exporting data to CSV:", e)
    finally:
        close_db(conn, cursor)

# Run the export function
export_data_to_csv()
