# Agriculture IoT use-case: AgriBrain

Authors: Hector Cano, Reid Falconer, Sebastian Wolf

## Project description

Bla bla bla

## Guide for folders:

- IoT Tools
- Dashboard
- Presentation

## Installation guides for IoT device

**Option 1:**
- **BalenaOS on IoT device collecting weather/humidity data**
- **Python IoT app deployed in a Docker container via BalenaCloud**
- **Grafana dashboard to analyze data**

Balena facilitates deploying Docker containers on IoT devices. It is built around a minimal Linux OS designed to run Docker containers. The IoT device is connected to a cloud-service through which applications packaged in docker containers can be deployed. Deploying a new application to connected devices is as simple as pushing a commit to the cloud - it then immediately starts running on our IoT device.

The steps to install balenaOS on your IoT are:

(1) Create an account on https://www.balena.io

(2) Follow instructions on balena.io to create an application. Let's call it 'agribrain'. Enter your Wifi credentials to allow the IoT device access to the internet. Then download the image for balenaOS

(3) Copy the image to your IoT SD storage, using balenaEtcher, insert it in the IoT device and power it up

(4) Voila: Find the Device online in your balena dashboard.

![](./IoT Tools/IoT device management on BalenaCloud.png?raw=true "IoT Device Management on Balena Cloud")

We are now ready to push an application to the IoT device via balenaCloud. For this, we need to install the balena CLI, which allows us to push applications to our balena account on balenaCloud, from where it gets deployed to our IoT device and starts running. To install the balena CLI, go to https://github.com/balena-io/balena-cli#standalone-install

After installing the CLI, we run ```$ balena login```, to connect the CLI to your balena account. Now we can simply issue ```$ balena push agribrain``` from within the folder of the application we built. This pushes our agribain application to the IoT device via the balenaCloud. The cloud builds a docker image for the application and handles the process of setting it up and running it on the IoT device. We can then control it from the balena dashboard.


**Option 2:**
- **Ubuntu on IoT device collecting weather/humidity data**
- **Python IoT app deployed via Azure**
- **RShiny dashboard to analyse data**
