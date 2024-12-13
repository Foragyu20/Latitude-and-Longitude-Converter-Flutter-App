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

# Fetch all coordinates
cursor.execute("SELECT id, latitude, longitude FROM coordinates")
rows = cursor.fetchall()

# Update each coordinate with DMS format
for row in rows:
    coord_id, lat, lng = row
    dms_lat = dd_to_dms(lat, "N", "S")
    dms_lng = dd_to_dms(lng, "E", "W")
    cursor.execute(
        "UPDATE coordinates SET dms_lat = %s, dms_lng = %s WHERE id = %s",
        (dms_lat, dms_lng, coord_id)
    )

db.commit()
print("Coordinates updated successfully!")
cursor.close()
db.close()
