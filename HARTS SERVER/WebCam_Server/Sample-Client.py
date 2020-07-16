from socket import *
from threading import *
import time
import cv2

HOST = '127.0.0.1'
PORT = 8080

client_socket = socket(AF_INET, SOCK_STREAM)
client_socket.connect((HOST, PORT))
print("Successfully connected to the server.")


def send(socket):
    while True:
        sendData = input(">>> ")
        socket.send(sendData.encode('UTF-8'))


def receive(socket):
    while True:
        recvData = socket.recv(1024)
        print("상대방 : " + recvData.decode('UTF-8'))

sender = Thread(target = send, args = (client_socket, ))
receiver = Thread(target = send, args = (client_socket, ))

cap = cv2.VideoCapture(0)