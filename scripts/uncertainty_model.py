import numpy as np
from database_connection import connect_to_db, close_db

def calculate_uq_metrics():
    """
    Calculate UQ metrics: mean, standard deviation, and reliability index for material quality.
    """
    conn, cursor = connect_to_db()
    if not conn:
        return

    cursor.execute("SELECT Test_Value FROM Material_Quality")
    test_values = [row['Test_Value'] for row in cursor.fetchall()]

    mean_value = np.mean(test_values)
    std_dev = np.std(test_values)
    reliability_index = mean_value / std_dev if std_dev != 0 else 0

    print(f"Mean Test Value: {mean_value}")
    print(f"Standard Deviation: {std_dev}")
    print(f"Reliability Index: {reliability_index}")

    close_db(conn, cursor)

# Run UQ metrics calculation
calculate_uq_metrics()
