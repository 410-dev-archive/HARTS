import keyboard
import orta_ttyin


def check_pressed_keys(a):
    for code in keyboard._pressed_events:
        line = str(code)
        if 0 <= int(line) <= 51:
            continue
        elif line == "55":
            print("cmd Pressed")
            #orta_ttyin.pushCommand("cmd")
            if 8 in keyboard._pressed_events or 9 in keyboard._pressed_events: # cmd+c / cmd+v
                print("No copy&pasting allowed.")
                #orta_ttyin.pushCommand("copy/paste attempted")
        elif line == "61":
            print("L-option Pressed")
            #orta_ttyin.pushCommand("option")
        elif line == "58":
            print("R-option Pressed")
            #orta_ttyin.pushCommand("option")
        elif line == "56":
            print("L-shift Pressed")
            #orta_ttyin.pushCommand("shift")
        elif line == "60":
            print("R-shift Pressed")
            #orta_ttyin.pushCommand("shift")
        elif line == "59":
            print("L-ctrl Pressed")
            #orta_ttyin.pushCommand("ctrl")
        elif line == "62":
            print("R-ctrl Pressed")
            #orta_ttyin.pushCommand("ctrl")
        elif line == "63":
            print("fn Pressed")
            #orta_ttyin.pushCommand("fn")
        
keyboard.on_press(check_pressed_keys)
keyboard.wait()

