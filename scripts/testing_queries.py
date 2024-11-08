from database_connection import connect_to_db, close_db

def test_database_queries():
    conn, cursor = connect_to_db()
    if not conn:
        return

    # Test query for Source Table
    cursor.execute("SELECT * FROM Source LIMIT 5")
    sources = cursor.fetchall()
    print("Sample records from Source table:")
    for source in sources:
        print(source)

    # Test query for Material Quality Table
    cursor.execute("SELECT * FROM Material_Quality LIMIT 5")
    materials = cursor.fetchall()
    print("\nSample records from Material_Quality table:")
    for material in materials:
        print(material)

    # Query for UQ metrics verification
    cursor.execute("""
        SELECT AVG(Test_Value) as mean_value,
               STDDEV(Test_Value) as std_dev
        FROM Material_Quality
    """)
    uq_metrics = cursor.fetchone()
    mean_value = uq_metrics['mean_value']
    std_dev = uq_metrics['std_dev']
    reliability_index = mean_value / std_dev if std_dev != 0 else 0

    print("\nCalculated UQ Metrics from Database Query:")
    print(f"Mean Test Value: {mean_value}")
    print(f"Standard Deviation: {std_dev}")
    print(f"Reliability Index: {reliability_index}")

    close_db(conn, cursor)

# Run the test queries
test_database_queries()
