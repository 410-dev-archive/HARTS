from socket import *

ReadStudentNameList = ["John Appleseed", "Benjamin Willis", "Tom Choi", "Sherlock Holmes"]
TEST_LINK = "https://docs.google.com/forms/d/e/1FAIpQLSd7kImJ6H3wqdHWYEssvSnDacKJkNNK2-JGhX2I6zSsY8I_5w/viewform?vc=0&c=0&w=1&usp=mail_form_link"

def send(sock, message):
	sock.send(message.encode('utf-8'))

def receive(sock):
	try:
		recvData = sock.recv(1024).decode('utf-8')
		if ReadStudentNameList.index(recvData.split(":")[1]) >= 0:
			if recvData.split(":")[0] == "JOIN":
				send(sock, "ACCEPTED:" + TEST_LINK)
				print(recvData.split(":")[1] + " joined the session.")
			else:
				print(recvData.split(":")[1] + " left the session.")
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
print('LISTENING ON PORT: ', port)
while True:
	serverSock.listen(1)
	connectionSock, addr = serverSock.accept()
	receive(connectionSock)
