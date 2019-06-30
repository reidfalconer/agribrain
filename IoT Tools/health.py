print 'Importing modules...'
from sense_hat import SenseHat
import math
import numpy as np
import itertools
import csv
import json
import sys

print 'Initializing sensor...'
# Sensor
hat = SenseHat()

# Acceleration factor
factor = 1

# Alert threshold
threshold = 2

# Send data to azure method
def send_data(data):
    json_data = json.dumps(data)
    block_blob.create_blob_from_text('example', 'data.json', json_data)

# Prepare output csv
with open('datahealth.csv', 'w') as data_file:
	writer = csv.writer(data_file, delimiter=',')
	writer.writerow(["x", "y", "z"])

print 'Load Done!\n'

# Main Loop
while True:
	try:
		acceleration = hat.get_accelerometer_raw()

		x = acceleration['x']
		y = acceleration['y']
		z = acceleration['z']

		x=round(x * factor)
		y=round(y * factor)
		z=round(z * factor)

		x_points = np.array([3,4]) - x
		y_points = np.array([3,4]) + y

		if(x_points.any() > 7):
                        x_points = np.array([6,7])

                if(x_points.any() < 0):
                        x_points = np.array([0,1])

                if(y_points.any() > 7):
                        y_points = np.array([6,7])

                if(y_points.any() < 0):
                        y_points = np.array([0,1])

		if np.sqrt(x**2 + y**2 + z**2) > threshold:
			color = (255, 0, 0)
			new_thread = Thread(target=send_data, args=(acceleration,))
    		new_thread.start()
		else:
			color = (0, 255, 0)

		hat.clear()
		for i,j in itertools.product(x_points, y_points):
                        hat.set_pixel(int(i), int(j), color)

		with open('datahealth.csv', 'a') as data_file:
			csv_file = csv.writer(data_file, delimiter=',')
			csv_file.writerow([acceleration['x'], acceleration['y'], acceleration['z']])

	except KeyboardInterrupt:
		break

# Clear sensor and quit
hat.clear()
print '\rSensor Cleared'
sys.exit()
