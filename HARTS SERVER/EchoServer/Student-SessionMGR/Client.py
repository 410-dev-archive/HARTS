from socket import *

dataset = ["ASK_ACCESS:gt5c5i:ng6a9h", "ASK_ACCESS:w:ng6a9h", "ASK_ACCESS:gt5c5i:w", "ASK_ACCESS:gt5c5i"]

def send(sock):
	sendData = input('>')
	sock.send(dataset[int(sendData)].encode('utf-8'))

def receive(sock):
	recvData = sock.recv(1024).decode('utf-8')
	if recvData == "NO":
		print("Invalid session.")
	elif recvData == "NARG":
		print("Program error. Please upgrade the client.")
	elif recvData == "ERROR":
		print("Server returned error. Please try again later, or try upgrading client.")
	elif recvData.startswith("YES:"):
		recvData = recvData.replace("YES:", "")
		print("IP address received: " + recvData)
		# Write recvData to file that client app can read
	else:
		print("RECEIVED: " + recvData)

port = 8080

clientSock = socket(AF_INET, SOCK_STREAM)
clientSock.connect(('127.0.0.1', port))

print('Connected to server.')

send(clientSock)
receive(clientSock)

