from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = 'passkey!'

# Database Connection
def get_db_connection():
    return mysql.connector.connect(
        host='localhost',
        user='eohst',
        password='DataBasepassword1!',
        database='queticousagedb'
    )

# Authentication Routes
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('INSERT INTO Users (username, password_hash, role, email) VALUES (%s, %s, %s, %s)',
                       (username, generate_password_hash(password), 'outfitter', email))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('SELECT * FROM Users WHERE username = %s', (username,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()

        if user and check_password_hash(user['password_hash'], password):
            session['user_id'] = user['user_id']
            session['role'] = user['role']
            if user['role'] == 'ranger':
                return redirect(url_for('ranger_dashboard'))
            else:
                return redirect(url_for('outfitter_dashboard'))
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

# Ranger Routes
@app.route('/ranger/dashboard')
def ranger_dashboard():
    if session.get('role') != 'ranger':
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT p.portage_id,
               l1.name AS lake_a,
               l2.name AS lake_b,
               p.distance_km,
               p.difficulty,
               p.maintenance_status
        FROM Portages p
        JOIN Lakes l1 ON p.from_lake_id = l1.lake_id
        JOIN Lakes l2 ON p.to_lake_id = l2.lake_id
    """)
    portages = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('ranger_dashboard.html', portages=portages)

@app.route('/ranger/traffic', methods=['GET', 'POST'])
def ranger_traffic():
    if session.get('role') != 'ranger':
        return redirect(url_for('login'))

    year = request.form.get('year')
    season = request.form.get('season')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get distinct years for dropdown
    cursor.execute("SELECT DISTINCT year FROM TouristTraffic ORDER BY year")
    available_years = [row['year'] for row in cursor.fetchall()]

    # Build main query with filters
    base_query = """
        SELECT l.name AS lake_name, season, year, SUM(visitors_count) AS total_visitors
        FROM TouristTraffic t
        JOIN Lakes l ON t.lake_id = l.lake_id
    """
    filters = []
    params = []

    if year:
        filters.append("year = %s")
        params.append(year)
    if season:
        filters.append("season = %s")
        params.append(season)

    if filters:
        base_query += " WHERE " + " AND ".join(filters)

    base_query += " GROUP BY l.name, season, year ORDER BY year, season, lake_name"

    cursor.execute(base_query, params)
    traffic_summary = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('ranger_traffic.html',
                           traffic_summary=traffic_summary,
                           available_years=available_years,
                           selected_year=year,
                           selected_season=season)

@app.route('/ranger/permits')
def ranger_permits():
    if session.get('role') != 'ranger':
        return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM Permits')
    permits = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('ranger_permits.html', permits=permits)

@app.route('/ranger/portages/update', methods=['POST'])
def ranger_update_portage():
    if session.get('role') != 'ranger':
        return redirect(url_for('login'))
    portage_id = request.form['portage_id']
    status = request.form['status']

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('UPDATE Portages SET maintenance_status = %s WHERE portage_id = %s', (status, portage_id))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('ranger_dashboard'))

# Outfitter Routes
@app.route('/outfitter/dashboard')
def outfitter_dashboard():
    if session.get('role') != 'outfitter':
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get all access points
    cursor.execute("SELECT access_id, name FROM AccessPoints")
    accesspoints = cursor.fetchall()

    # Get all lakes
    cursor.execute("SELECT lake_id, name FROM Lakes")
    lakes = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('outfitter_dashboard.html',
                           accesspoints=accesspoints,
                           lakes=lakes)

@app.route('/outfitter/permits/new', methods=['POST'])
def outfitter_new_permit():
    if session.get('role') != 'outfitter':
        return redirect(url_for('login'))
    access_id = request.form['access_id']
    issue_date = request.form['issue_date']
    group_size = request.form['group_size']
    duration_days = request.form['duration_days']

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('INSERT INTO Permits (access_id, issue_date, group_size, duration_days, issued_by) VALUES (%s, %s, %s, %s, %s)',
                   (access_id, issue_date, group_size, duration_days, session['user_id']))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('outfitter_dashboard'))

@app.route('/outfitter/permits/history')
def outfitter_permit_history():
    if session.get('role') != 'outfitter':
        return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM Permits WHERE issued_by = %s', (session['user_id'],))
    permits = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('outfitter_permits.html', permits=permits)

@app.route('/outfitter/log_traffic', methods=['POST'])
def outfitter_log_traffic():
    if session.get('role') != 'outfitter':
        return redirect(url_for('login'))

    lake_id = request.form['lake_id']
    season = request.form['season']
    year = request.form['year']
    visitors_count = request.form['visitors_count']

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO TouristTraffic (lake_id, season, year, visitors_count)
        VALUES (%s, %s, %s, %s)
    """, (lake_id, season, year, visitors_count))
    conn.commit()
    cursor.close()
    conn.close()

    return redirect(url_for('outfitter_dashboard'))

@app.route('/')
def home():
    return redirect(url_for('login'))

# Run App
if __name__ == '__main__':
    app.run(debug=True)