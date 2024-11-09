import numpy as np
from database_connection import connect_to_db, close_db

def calculate_uq_metrics():
    """
    Calculate UQ metrics: mean, standard deviation, and reliability index for material quality.
    Stores results in the UQ_Results table.
    """
    conn, cursor = connect_to_db()
    if not conn:
        return

    try:
        # Fetch test values
        cursor.execute("SELECT test_value FROM Material_Quality")
        rows = cursor.fetchall()
        test_values = [float(row['test_value']) for row in rows]

        # Perform UQ calculations
        mean_value = np.mean(test_values)
        std_dev = np.std(test_values)
        reliability_index = mean_value / std_dev if std_dev != 0 else 0

        # Print calculated metrics
        print(f"Mean Test Value: {mean_value}")
        print(f"Standard Deviation: {std_dev}")
        print(f"Reliability Index: {reliability_index}")

        # Insert results into UQ_Results table
        cursor.execute(
            "INSERT INTO UQ_Results (Source_ID, Mean_Value, Standard_Deviation, Reliability_Index) VALUES (%s, %s, %s, %s)",
            ('S001', mean_value, std_dev, reliability_index)  # Replace 'S001' if you want to specify a different source or add dynamic handling
        )
        conn.commit()
        print("UQ metrics successfully inserted into UQ_Results table.")

    except Exception as e:
        print("Error during UQ calculation or database insertion:", e)
    finally:
        close_db(conn, cursor)

# Run the UQ metrics calculation and storage
calculate_uq_metrics()
