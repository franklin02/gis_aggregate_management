import numpy as np
from database_connection import connect_to_db, close_db

def calculate_uq_metrics_for_all_sources():
    """
    Calculate UQ metrics for each Source_ID in Material_Quality and store them in UQ_Results.
    """
    conn, cursor = connect_to_db()
    if not conn:
        return

    try:
        # Get all unique Source_IDs from Material_Quality
        cursor.execute("SELECT DISTINCT Source_ID FROM Material_Quality")
        source_ids = [row['source_id'] for row in cursor.fetchall()]

        for source_id in source_ids:
            # Fetch test values for each Source_ID
            cursor.execute("SELECT test_value FROM Material_Quality WHERE Source_ID = %s", (source_id,))
            rows = cursor.fetchall()
            test_values = [float(row['test_value']) for row in rows]

            # Perform UQ calculations
            mean_value = np.mean(test_values)
            std_dev = np.std(test_values)
            reliability_index = mean_value / std_dev if std_dev != 0 else 0

            # Insert or update metrics in UQ_Results table
            cursor.execute(
                """
                INSERT INTO UQ_Results (Source_ID, Mean_Value, Standard_Deviation, Reliability_Index)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (Source_ID) DO UPDATE
                SET Mean_Value = EXCLUDED.Mean_Value,
                    Standard_Deviation = EXCLUDED.Standard_Deviation,
                    Reliability_Index = EXCLUDED.Reliability_Index
                """,
                (source_id, mean_value, std_dev, reliability_index)
            )
        
        conn.commit()
        print("UQ metrics calculated and updated for all sources in UQ_Results.")

    except Exception as e:
        print("Error during UQ calculation or database insertion:", e)
    finally:
        close_db(conn, cursor)

# Run the UQ metrics calculation and storage
calculate_uq_metrics_for_all_sources()
