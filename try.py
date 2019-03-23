import serial
import time
import requests
import json
firebase_url = 'https://bmu-hackathon.firebaseio.com/'
#Connect to Serial Port for communication

#Setup a loop to send Temperature values at fixed intervals
#in seconds
fixed_interval = 1
while 1:
  try:
    current = 30
    
    #current time and date
    time_hhmmss = time.strftime('%H:%M:%S')
    date_mmddyyyy = time.strftime('%d/%m/%Y')
    
    print current + ',' + time_hhmmss + ',' + date_mmddyyyy
    
    #insert record
    data = {'date':date_mmddyyyy,'time':time_hhmmss,'value':current}
    result = requests.post(firebase_url + '/' + 'bmu-hackathon' + '/temperature.json', data=json.dumps(data))
    
    print 'Record inserted. Result Code = ' + str(result.status_code) + ',' + result.text
    time.sleep(fixed_interval)
  except IOError:
    print('Error! Something went wrong.')
  time.sleep(fixed_interval)