import csv
from database_connection import connect_to_db, close_db

def clear_table(table_name):
    conn, cursor = connect_to_db()
    if not conn:
        return
    try:
        cursor.execute(f"DELETE FROM {table_name};")
        conn.commit()
        print(f"All records deleted from {table_name}.")
    except Exception as e:
        print(f"Error clearing {table_name}: {e}")
    finally:
        close_db(conn, cursor)

def populate_table_from_csv(table_name, csv_file):
    conn, cursor = connect_to_db()
    if not conn:
        return

    try:
        with open(csv_file, 'r') as file:
            reader = csv.DictReader(file)
            print(f"Headers in {csv_file}: {reader.fieldnames}")
            for row in reader:
                columns = ', '.join(row.keys())
                values = ', '.join(['%s'] * len(row))
                sql = f"INSERT INTO {table_name} ({columns}) VALUES ({values})"
                cursor.execute(sql, list(row.values()))

        conn.commit()
        print(f"Data loaded into {table_name} from {csv_file} successfully.")
    except Exception as e:
        print(f"Error loading data into {table_name} from {csv_file}: {e}")
    finally:
        close_db(conn, cursor)

# Clear tables in the correct dependency order
clear_table('Material_Quality')
clear_table('Environmental_Compliance')
clear_table('Operational_Info')
clear_table('Source')  # Clear Source last as it is referenced by other tables

# Populate tables from CSV files
populate_table_from_csv('Source', 'data/source_data.csv')
populate_table_from_csv('Material_Quality', 'data/material_quality.csv')
populate_table_from_csv('Environmental_Compliance', 'data/environmental_compliance.csv')
populate_table_from_csv('Operational_Info', 'data/operational_info.csv')
