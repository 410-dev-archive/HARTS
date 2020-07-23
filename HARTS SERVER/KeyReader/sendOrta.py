import os

def key_sender(key):
    OrtaOSPointer = open(os.environ['TTYIN'], "w", encoding="utf8")
    OrtaOSPointer.write(key)
    OrtaOSPointer.close()