### Configuration

#### Sensor offsets
If required, this project supports offsetting of the measured values before they are recorded in the database.

To offset temperature, add a balenaCloud environment variable called `BALENASENSE_TEMP_OFFSET`, and add an offset in degrees C.

To offset humidity, add a balenaCloud environment variable called `BALENASENSE_HUM_OFFSET` and add a value in % RH.

To adjust the pressure sensor and compensate for altitude, add a balenaCloud environment variable called `BALENASENSE_ALTITUDE` and set it to your altitude above sea level in meters.

#### Data outputs
Versions of balenaSense after v1.5 introduce [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) to capture the data from the sensor which permits the feed of data to other sources in addition to the internal InfluxDB instance.

##### Feeding to InfluxDB cloud 2.0
Configure the following environment variables within the balenaCloud dashboard to enable the feed to the InfluxDB Cloud 2.0 service:
* `INFLUX_BUCKET` - the name of the bucket you created
* `INFLUX_ORG` - your login email address used for InfluxDB cloud
* `INFLUX_TOKEN` - the read/write token for your bucket

##### Feeding to an external InfluxDB instance
Configure the following environment variables within the balenaCloud dashboard to enable a feed to an external InfluxDB instance:
* `INFLUXDB_EXTERNAL_URL` - the HTTP URL to your InfluxDB instance
* `INFLUXDB_EXTERNAL_USERNAME` - the username for authentication to your InfluxDB instance
* `INFLUXDB_EXTERNAL_PASSWORD` - the password for authentication to your InfluxDB instance

##### Multiple sensors
If you're feeding to one of the above services and have multiple sensors, you can add the `BALENASENSE_ID` variable to each of your devices. This will then be passed to the output database along with the measurements, allowing you to filter and plot metrics from each device individually.
