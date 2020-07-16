from socket import *
from threading import *
import time

HOST = ''
PORT = 8080

server_socket = socket(AF_INET, SOCK_STREAM)
server_socket.bind((HOST, PORT))
server_socket.listen()
print("Server is successfully booted.")
print("Waiting for client...")

connection_socket, connection_addr = server_socket.accept()
print(str(connection_addr) + " is connected.")

def send(socket):
    while True:
        sendData = input (">>> ")
        socket.send(sendData.encode('UTF-8'))

def receive(socket):
    while True:
        recvData = socket.recv(1024)
        print("상대방 : " + recvData.decode('UTF-8'))

sender = Thread(target = send, args = (connection_socket, ))
receiver = Thread(target = receive, args = (connection_socket, ))

sender.start()
receiver.start()

while True:
    time.sleep(1)
    pass
