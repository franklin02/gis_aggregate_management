from database_connection import connect_to_db, close_db

# Test connection
conn, cursor = connect_to_db()
if conn:
    print("Connection successful!")
    close_db(conn, cursor)
else:
    print("Connection failed.")
