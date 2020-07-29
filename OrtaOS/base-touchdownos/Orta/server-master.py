from socket import *
import sys

def send(sock, toSend):
	sock.send(toSend.encode('utf-8'))
	print("[*] Data sent:" + toSend)

def receive(sock):
	recvData = sock.recv(1024).decode('utf-8')
	print("[*] Received.")
	if recvData == "NO":
		print("[-] Invalid session.")
		IPRecord = open("/tmp/HARTS/error.harts", "w")
		IPRecord.write("invalid")
		IPRecord.close()
	elif recvData == "NARG":
		print("[-] Program error. Please upgrade the client.")
		IPRecord = open("/tmp/HARTS/error.harts", "w")
		IPRecord.write("error")
		IPRecord.close()
	elif recvData == "ERROR":
		print("[-] Server returned error. Please try again later, or try upgrading client.")
	elif recvData.startswith("YES:"):
		recvData = recvData.replace("YES:", "")
		print("[*] IP address received: " + recvData)
		IPRecord = open("/tmp/HARTS/tip.harts", "w")
		IPRecord.write(recvData)
		IPRecord.close()
	else:
		print("[*] RECEIVED: " + recvData)

try:
	if sys.argv[1].startswith("ASK_ACCESS:"):
		f = 0 # Dummy code
except:
	exit(0)

print("[*] Connecting Socket...")
port = 8080
clientSock = socket(AF_INET, SOCK_STREAM)
print("[*] Sending packet: " + sys.argv[1])
clientSock.connect(('127.0.0.1', port))
send(clientSock, sys.argv[1])
receive(clientSock)

