import argparse
import mysql.connector
from werkzeug.security import generate_password_hash

def add_ranger(username, password, email):
    conn = mysql.connector.connect(
        host='localhost',
        user='eohst',
        password='DataBasepassword1!',   # update if needed
        database='queticousagedb'
    )
    cursor = conn.cursor()

    password_hash = generate_password_hash(password)

    cursor.execute(
        'INSERT INTO Users (username, password_hash, role, email) VALUES (%s, %s, %s, %s)',
        (username, password_hash, "ranger", email)
    )

    conn.commit()
    cursor.close()
    conn.close()
    print(f'Ranger "{username}" added successfully.')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Add a new ranger user to the database.')
    parser.add_argument('username', help="The ranger's username")
    parser.add_argument('password', help="The ranger's password")
    parser.add_argument('email', help="The ranger's email")

    args = parser.parse_args()
    add_ranger(args.username, args.password, args.email)

