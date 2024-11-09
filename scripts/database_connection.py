import psycopg2
from psycopg2.extras import RealDictCursor

def connect_to_db():
    """
    Connects to PostgreSQL database and returns the connection and cursor.
    """
    try:
        conn = psycopg2.connect(
            dbname="gis_aggregate_db",
            user="postgres",       # Replace this with your actual PostgreSQL username
            password="Lu977908",    # Replace this with your actual PostgreSQL password
            host="localhost",
            port="5432"
        )
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        print("Connected to the database successfully.")
        return conn, cursor
    except Exception as e:
        print("Error connecting to the database:", e)
        return None, None

def close_db(conn, cursor):
    """
    Closes the database connection and cursor.
    """
    cursor.close()
    conn.close()
    print("Database connection closed.")
