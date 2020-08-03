import serial
import os
from datetime import datetime
from serial.tools.list_ports import comports

def main():
    
    ports = [p.name for p in comports()]
    print(ports)

    #Creating the file name
    now = datetime.now()
    fileName = ''
    fileName = input("name")
    fileName = os.getcwd() + '/' + fileName + '-' + now.strftime("%d/%m/%Y %H:%M:%S") + '.csv'


    #Reading data from serial port
    data = ''
    numberOfSamples = 10
    with serial.Serial('/dev/tty.usbmodem14401', 9600, timeout=1) as wristSensor:
        i = 0
        while i < numberOfSamples:
            k = wristSensor.readline().decode("utf-8")
            if len(k) > 1:
                data += k
                i += 1
                print('reading sample ' + str(i))

    #saving data into file
    file1 = open(fileName,"w") 
    file1.write(data) 
    file1.close() 
    print(file1);

if __name__ == "__main__":
    main()
