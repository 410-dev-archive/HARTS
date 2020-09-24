from socket import *


def send(sock):
    sendData = input('>>>')
    sock.send(sendData.encode('utf-8'))


def receive(sock):
    recvData = sock.recv(1024)
    print('상대방 :', recvData.decode('utf-8'))


port = 8080

serverSock = socket(AF_INET, SOCK_STREAM)
serverSock.bind(('', port))
serverSock.listen(1)

print('%d번 포트로 접속 대기중...'%port)

connectionSock, addr = serverSock.accept()

print(str(addr), '에서 접속되었습니다.')

while True:

    receive(connectionSock)

    send(connectionSock)