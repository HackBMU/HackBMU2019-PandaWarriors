import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import serial
import time
import requests
import json

# Fetch the service account key JSON file contents
cred = credentials.Certificate('firebase-adminsdk.json')
# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://bmu-hackathon.firebaseio.com/'
})

ref = db.reference('/')
ref.set({
        'devices': 
            {
                'Laptop': {
                    'color': 'red',
                    'Status': 'OFF',
                    'power': 40,
                    #'length': 2
                },
                'Bulb': {
                    'color': 'green',
                    'Status': 'OFF',
                    'power': 100,
                    #'length': 3
                },
                'Hair Dryer': {
                    'color': 'yellow',
                    'Status': 'OFF',
                    'power': 1000,
                    #'length': 1
                }
            }
        })

ser = serial.Serial('/dev/ttyACM1', 9600, timeout=0)

cur = 0

while 1:
	try:
		current = ser.readline()
    	difference = current - cur
    	if(difference>30 && difference<50):
      		#Update Data Values
      		ref = db.reference('boxes')
			box_ref = ref.child('box001')
			box_ref.update({
			    'color': 'blue'
			})
