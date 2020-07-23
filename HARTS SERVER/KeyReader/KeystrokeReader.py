import keyboard
import sendOrta

def check_pressed_keys(a):
    for code in keyboard._pressed_events:
        line = str(code)
        if line == "55":
            print("L-cmd Pressed")
            #sendOrta.OrtaOSPointer("lcmd")
        elif line == "61":
            print("L-option Pressed")
            #sendOrta.OrtaOSPointer("loption")
        elif line == "58":
            print("R-option Pressed")
            #sendOrta.OrtaOSPointer("roption")
        elif line == "56":
            print("L-shift Pressed")
            #sendOrta.OrtaOSPointer("lshift")
        elif line == "60":
            print("R-shift Pressed")
            #sendOrta.OrtaOSPointer("rshift")
        elif line == "59":
            print("ctrl Pressed")
            #sendOrta.OrtaOSPointer("ctrl")

keyboard.hook(check_pressed_keys)
keyboard.wait() # forever loop

