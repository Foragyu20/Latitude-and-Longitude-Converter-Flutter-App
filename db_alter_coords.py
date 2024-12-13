import mysql.connector

# Connect to MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="coordinates_db"
)

cursor = db.cursor()

# Function to convert Decimal Degrees to DMS
def dd_to_dms(value, pos_dir, neg_dir):
    direction = pos_dir if value >= 0 else neg_dir
    value = abs(value)
    degrees = int(value)
    minutes = int((value - degrees) * 60)
    seconds = round((value - degrees - minutes / 60) * 3600, 2)
    return f"{degrees}°{minutes}'{seconds}\"{direction}"
