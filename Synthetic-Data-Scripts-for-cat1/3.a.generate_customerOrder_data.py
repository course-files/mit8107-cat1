# pip install mysql-connector-python

import mysql.connector
import random
from random import randint
from datetime import datetime, timedelta

# Connect to the database
conn = mysql.connector.connect(
    host='localhost',
    port=3307,
    user='retail-pos-system',
    password='point-of-sale',
    database='<your_student_ID_number>_cat1'
)

cursor = conn.cursor()

# Helper Functions
def random_date(start, end):
    """Generate a random datetime between start and end dates."""
    delta = end - start
    random_seconds = random.randint(0, int(delta.total_seconds()))
    return start + timedelta(seconds=random_seconds)

# Retrieve existing customerNumber and orderStatusID
cursor.execute("SELECT customerNumber FROM customer")
customer_numbers = [row[0] for row in cursor.fetchall()]
# print("Customer Numbers:", customer_numbers)  # Temporary output for confirmation

cursor.execute("SELECT orderStatusID FROM orderStatus")
order_status_ids = [row[0] for row in cursor.fetchall()]
# print("Order Status IDs:", order_status_ids)  # Temporary output for confirmation

start_date = datetime(2024, 7, 1)
end_date = datetime(2025, 2, 24)

# Insert 80 orders
for _ in range(80):
    order_date = random_date(start_date, end_date)
    required_date = order_date + timedelta(days=randint(0, 4), hours=randint(0, 23), minutes=randint(5, 59), seconds=randint(0, 59))
    dispatch_date = (order_date + timedelta(days=randint(0, 5), hours=randint(0, 23), minutes=randint(5, 59), seconds=randint(0, 59)) 
                    if random.choices([True, False], weights=[0.8, 0.2])[0] else None)
    order_status_id = order_status_ids[randint(0, len(order_status_ids) - 1)]
    customer_number = customer_numbers[randint(0, len(customer_numbers) - 1)]

    # This inserts the data as it is generated
    cursor.execute("""
        INSERT INTO customerOrder (orderDate, requiredDate, dispatchDate, orderStatusID, customerNumber)
        VALUES (%s, %s, %s, %s, %s)
    """, (order_date, required_date, dispatch_date, order_status_id, customer_number))
    
    sql_statement = """INSERT INTO customerOrder (orderDate, requiredDate, dispatchDate, orderStatusID, customerNumber) VALUES ('%s', '%s', %s, %d, %d);""" % (order_date, required_date, 'NULL' if dispatch_date is None else f"'{dispatch_date}'", order_status_id, customer_number)

    with open('3.b.DML_customerOrder_data.sql', 'a') as f:
        f.write(sql_statement + '\n')

# Commit the transaction
conn.commit()

# Close the connection
cursor.close()
conn.close()