from socket import *

ReadStudentNameList = ["Benjamin Franklin", "Ivan Ko", "Sherlock Holmes"]
JoinedStudentList = []
TEST_LINK = "https://docs.google.com/forms/d/e/1FAIpQLSd7kImJ6H3wqdHWYEssvSnDacKJkNNK2-JGhX2I6zSsY8I_5w/viewform?vc=0&c=0&w=1&usp=mail_form_link"

def send(sock, message):
	sock.send(message.encode('utf-8'))
	print("[*] Returned: " + message)

def receive(sock):
	try:
		recvData = sock.recv(1024).decode('utf-8')
		if recvData.startswith("JOIN"):

			# On Join signal
			# JOIN:NAME
			if recvData.split(":")[1] in ReadStudentNameList: 
				send(sock, "ACCEPTED:" + TEST_LINK)
				JoinedStudentList.append(recvData.split(":")[1])
				print(recvData.split(":")[1] + " joined the session.")
			else:
				send(sock, "REJECTED")
				print(recvData + " tried to join the session, but was rejected.")

		elif recvData.startswith("LEAVE"):

			# On leave signal
			# LEAVE:NAME
			if recvData.split(":")[1] in JoinedStudentList:
				JoinedStudentList.pop(recvData.split(":")[1])
				print(recvData.split(":")[1] + " left the session.")
				send(sock, "OK")
			else:
				print(recvData.split(":")[1] + " tried to leave the session, but was not in session.")
				send(sock, "REJECTED")

		elif recvData.startswith("QUESTION"):

			# On Question signal
			# QUESTION:NAME:CONTENTS
			print(recvData.split(":")[1] + " asked question: " + recvData.split(":")[2])
			send(sock, "OK")

		elif recvData.startswith("KEYEVENT"):

			# On keyboard signal
			# KEYEVENT:NAME:PRESSED KEY
			print("Detected " + recvData.split(":")[1] + "\'s suspicious keystroke: " + recvData.split(":")[2])
			send(sock, "OK")

		elif recvData.startswith("ASK_URL"):

			# On url ask
			# ASK_URL:NAME
			if recvData.split(":")[1] in JoinedStudentList:
				print(recvData.split(":")[1] + "'s client asked for test URL.")
				send(sock, TEST_LINK)
			else:
				print(recvData.split(":")[1] + " tried to figure out the test URL.")
				send(sock, "REJECT")

		else:
			print("Received unknown data: " + recvData)

	except:
		send(sock, "ERROR")
		print("Received " + recvData + "\" but the server encountered an error.")

port = 27667
serverSock = socket(AF_INET, SOCK_STREAM)
serverSock.bind(('', port))
print('LISTENING ON PORT: ', port)
while True:
	serverSock.listen(1)
	connectionSock, addr = serverSock.accept()
	receive(connectionSock)
