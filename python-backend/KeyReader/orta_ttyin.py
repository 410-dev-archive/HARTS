import os

def pushCommand(key):
    with open(os.environ['TTYIN'],"w",encoding="utf8") as OrtaOSPointer:
        OrtaOSPointer.write(key)

def pullOutput():
    with open(os.environ['TTYOUT'],"r",encoding="utf8") as OrtaOSPointer:
        return OrtaOSPointer.read()