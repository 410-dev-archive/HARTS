from socket import *

ReadStudentNameList = ["John Appleseed", "Benjamin Willis", "Tom Choi", "Sherlock Holmes"]
TEST_LINK = "https://www.google.com"

def send(sock, message):
	sock.send(message.encode('utf-8'))

def receive(sock):
	try:
		recvData = sock.recv(1024).decode('utf-8')
		if ReadStudentNameList.index(recvData) >= 0:
			send(sock, "ACCEPTED:" + TEST_LINK)
			print(recvData + " joined the session.")
		else:
			send(sock, "REJECTED")
			print(recvData + " tried to join the session, but was rejected.")
	except ValueError:
		send(sock, "REJECTED")
		print(recvData + " tried to join the session, but was rejected.")
	except:
		send(sock, "ERROR")
		print(recvData + " tried to join the session, but the server encountered an error.")

port = 27667
serverSock = socket(AF_INET, SOCK_STREAM)
serverSock.bind(('', port))
print('Session is now open on port: ', port)
while True:
	serverSock.listen(1)
	connectionSock = serverSock.accept()
	receive(connectionSock)

