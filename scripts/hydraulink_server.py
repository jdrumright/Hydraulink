import socket
import threading
from gpiozero import LED
from time import sleep

class GPIOControl():
    def __init__(self, pins=[14, 15, 20, 21]):
        self.pins = {}
        for pin in pins:
            self.pins[pin] = LED(pin)
            print("Set up pin",pin)
        print(self.pins)

    # turn off GPIO pin
    def gpio_off(self, number):
        self.pins[number].off()

    # turn on GPIO pin
    def gpio_on(self, number):
        self.pins[number].on()

    # return pin number from server message
    def get_pin(self, string):
        if string is "gpio_FL":
            return(14)
        elif string is "gpio_FR":
            return(15)
        elif string is "gpio_BL":
            return(20)
        elif string is "gpio_BR":
            return(21)
        else:
            return("Error")

def create_server(ip_add = '', port = 9999):
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((ip_add, port))
    server.listen(1)  # max backlog of connections
    print('Listening on {}:{}'.format(ip_add, port))
    return server

def handle_message(msg):
    pass

def server_loop(server):
    while True:
        data = conn.recv(1024)
        if not data:
          break
        else:
          print("message: ", data)
          conn.send("server:OK")

if __name__ == '__main__':
    server = create_server()
    while True:
        conn, add = server.accept()
        print("Connected to", add)
        server_loop(server)
    conn.close()
