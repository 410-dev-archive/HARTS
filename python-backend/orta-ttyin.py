import os

def pushCommand(key):
    OrtaOSPointer = open(os.environ['TTYIN'], "w")
    OrtaOSPointer.write(key)
    OrtaOSPointer.close()

def pullOutput():
	OrtaOSPointer = open(os.environ['TTYOUT'], "r")
    output = OrtaOSPointer.read()
    OrtaOSPointer.close()
    return output