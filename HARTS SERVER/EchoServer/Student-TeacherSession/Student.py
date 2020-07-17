from socket import *

readUsername = "John Appleseed"

def send(sock):
	sock.send(readUsername.encode('utf-8'))

def receive(sock):
	recvData = sock.recv(1024).decode('utf-8')
	if recvData == "REJECTED":
		print("You are not accepted.")
	elif recvData.startswith("ACCEPTED:"):
		print("You are accepted.")
		TestLink = recvData.replace("ACCEPTED:", "")
		# Write TestLink for HARTS to read
	else:
		print("ERROR: Received unknown data: \"" + recvData + "\"")

port = 27667

clientSock = socket(AF_INET, SOCK_STREAM)
clientSock.connect(('127.0.0.1', port))

print('Connected to server.')

send(clientSock)
receive(clientSock)

