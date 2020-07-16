from socket import *


def send(sock):
    sendData = input('>>>')
    sock.send(sendData.encode('utf-8'))


def receive(sock):
    recvData = sock.recv(1024)
    print('상대방 :', recvData.decode('utf-8'))


port = 8080

clientSock = socket(AF_INET, SOCK_STREAM)
clientSock.connect(('127.0.0.1', port))

print('접속 완료')

while True:
    receive(clientSock)

    send(clientSock)