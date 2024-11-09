import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from database_connection import connect_to_db, close_db

def fetch_test_values():
    """Fetch test values from the database and convert them to floats."""
    conn, cursor = connect_to_db()
    if not conn:
        return None

    try:
        cursor.execute("SELECT test_value FROM Material_Quality")
        rows = cursor.fetchall()
        # Convert Decimal values to float
        test_values = [float(row['test_value']) for row in rows]
        return test_values
    except Exception as e:
        print("Error fetching test values:", e)
        return None
    finally:
        close_db(conn, cursor)

def plot_histogram(test_values):
    """Plot histogram to show distribution of test values."""
    plt.figure(figsize=(10, 6))
    plt.hist(test_values, bins=10, color="skyblue", edgecolor="black")
    plt.title("Distribution of Test Values")
    plt.xlabel("Test Value")
    plt.ylabel("Frequency")
    plt.grid(True)
    plt.show()

def plot_boxplot(test_values):
    """Plot box plot to identify outliers visually."""
    plt.figure(figsize=(10, 6))
    plt.boxplot(test_values, vert=False, patch_artist=True, boxprops=dict(facecolor="skyblue"))
    plt.title("Box Plot of Test Values")
    plt.xlabel("Test Value")
    plt.grid(True)
    plt.show()

def detect_outliers(test_values):
    """Identify outliers using the IQR method."""
    # Convert test values to a Pandas Series for easy calculation
    test_values_series = pd.Series(test_values)

    # Calculate Q1 (25th percentile) and Q3 (75th percentile)
    Q1 = test_values_series.quantile(0.25)
    Q3 = test_values_series.quantile(0.75)
    IQR = Q3 - Q1

    # Define outliers as values outside of 1.5 * IQR from Q1 and Q3
    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR
    outliers = test_values_series[(test_values_series < lower_bound) | (test_values_series > upper_bound)]

    print(f"Outliers:\n{outliers}")
    print(f"Lower Bound: {lower_bound}, Upper Bound: {upper_bound}")
    return outliers

def main():
    # Fetch test values from the database
    test_values = fetch_test_values()
    if not test_values:
        print("No data available to plot.")
        return

    # Plot histogram
    plot_histogram(test_values)

    # Plot box plot
    plot_boxplot(test_values)

    # Detect and print outliers
    outliers = detect_outliers(test_values)
    if not outliers.empty:
        print(f"Found {len(outliers)} outliers in the test values.")
    else:
        print("No outliers found in the test values.")

# Run the analysis
main()
