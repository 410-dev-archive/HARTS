from socket import *
import sys

def send(sock, readUsername):
	sock.send(readUsername.encode('utf-8'))

def receive(sock):
	recvData = sock.recv(1024).decode('utf-8')
	if recvData == "REJECTED":
		print("You are not accepted.")
	elif recvData.startswith("ACCEPTED:"):
		print("You are accepted.")
		recvData = recvData.replace("ACCEPTED:", "")
		Host = open("/tmp/HARTS/testhost.harts", "w")
		Host.write(recvData)
		Host.close()
	else:
		print("ERROR: Received unknown data: \"" + recvData + "\"")

try:
	if "." in sys.argv[0]:
		f = 0 # Dummy code
except:
	exit(0)

port = 27667

clientSock = socket(AF_INET, SOCK_STREAM)
TeacherCOM = open("/tmp/HARTS/tip.harts", "r")
clientSock.connect((TeacherCOM.read(), port))
TeacherCOM.close()

send(clientSock)
receive(clientSock)

