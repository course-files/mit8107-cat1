import sys
# pip install mysql-connector-python
import mysql.connector

# Database connection
conn = mysql.connector.connect(
    host='localhost',
    port=3307,
    user='root',
    password='5trathm0re',
    database='<your_student_ID_number>_cat1'
)
cursor = conn.cursor()

def execute_sql_file(filename):
    with open(filename, 'r') as file:
        sql_commands = file.read().split(';')
        for i, command in enumerate(sql_commands):
            if command.strip():
                try:
                    cursor.execute(command)
                    conn.commit()
                    print(f"Executed command {i+1}/{len(sql_commands)}")
                except mysql.connector.Error as err:
                    print(f"Error: {err}")
                    conn.rollback()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python 0.b.load_synthetic_data.py <sql_file>")
        sys.exit(1)
    sql_file = sys.argv[1]
    execute_sql_file(sql_file)

# Close the cursor and connection
cursor.close()
conn.close()
