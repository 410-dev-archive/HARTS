from socket import *

SAMPLE_validSessions = ["gt5c5i", "tf3wp7", "dmlg1z"]
SAMPLE_sessionPasswords = ["ng6a9h", "vy1tqd", "2l4pds"]
SAMPLE_eachSessionTeacherIP = ["127.0.0.1", "127.0.0.1", "127.0.0.1"]

def send(sock, toSend):
	sock.send(toSend.encode('utf-8'))

	
# Client should send with this format:

# ASK_ACCESS:gt5c5i:ng6a9h
# ASK_ACCESS:[sessionid]:[password]
# Then server returns YES:[TEACHER IP] / NO

def receive(sock):
	try:
		recvData = sock.recv(1024).decode('utf-8')
		if recvData.startswith("ASK_ACCESS:"):
			toParse = recvData.split(":")
			if len(toParse) == 3:
				if SAMPLE_validSessions.index(toParse[1]) >= 0:
					if SAMPLE_sessionPasswords[SAMPLE_validSessions.index(toParse[1])] == toParse[2]:
						send(sock, "YES:" + SAMPLE_eachSessionTeacherIP[SAMPLE_validSessions.index(toParse[1])])
					else:
						send(sock, "NO")
				else:
					send(sock, "NO")
			else:
				send(sock, "NARG")
	except ValueError:
		send(sock, "NO")
	except:
		send(sock, "ERROR")


port = 8080

serverSock = socket(AF_INET, SOCK_STREAM)
serverSock.bind(('', port))

print('LISTENING ON PORT: ', port)
while True:
	serverSock.listen(1)
	connectionSock, addr = serverSock.accept()
	print('CONNECTED:' + str(addr))
	receive(connectionSock)
