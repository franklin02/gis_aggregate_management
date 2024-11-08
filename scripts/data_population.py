import csv
from database_connection import connect_to_db, close_db

def populate_table_from_csv(table_name, csv_file):
    conn, cursor = connect_to_db()
    if not conn:
        return

    with open(csv_file, 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            columns = ', '.join(row.keys())
            values = ', '.join(['%s'] * len(row))
            sql = f"INSERT INTO {table_name} ({columns}) VALUES ({values})"
            cursor.execute(sql, list(row.values()))

    conn.commit()
    print(f"Data loaded into {table_name} from {csv_file}")
    close_db(conn, cursor)

# Usage example
populate_table_from_csv('Source', 'data/source_data.csv')
populate_table_from_csv('Material_Quality', 'data/material_quality.csv')
populate_table_from_csv('Environmental_Compliance', 'data/environmental_compliance.csv')
populate_table_from_csv('Operational_Info', 'data/operational_info.csv')
