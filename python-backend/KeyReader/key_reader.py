import sys # cache disable
sys.dont_write_bytecode = True

from pynput.keyboard import Key, Listener # $ pip3 install pynput
import orta_ttyin, os

cmd_pressed = False # is command pressed? initial value

def toggle_cmd_pressed(): # cmd DOWN -> true, cmd UP -> false
    global cmd_pressed
    cmd_pressed = not cmd_pressed

def on_press(key):
    if len(str(key)) > 3: # dismisses 1-letter key e.g. = 'p'
        msg = ('{0} DOWN'.format(key)).replace("Key.","") # format = button UP
        print("keyevent", msg)
        #orta_ttyin.pushCommand("keyevent"+msg) #send to ortaOS
    if key in {Key.cmd,Key.cmd_l,Key.cmd_r}:
        toggle_cmd_pressed()
    elif cmd_pressed == True:
        if str(key) in {"'c'","'x'","'v'"}:
            print("commandkeyevent Copy&Paste") 
            #orta_ttyin.pushCommand("commandkeyevent Copy&Paste")
        elif str(key) in {"'w'","'q'"}:
            print("commandkeyevent ForceQuit") 
            #orta_ttyin.pushCommand("commandkeyevent ForceQuit")

def on_release(key):
    if key in {Key.cmd,Key.cmd_l,Key.cmd_r}: # only sends cmd UP
        toggle_cmd_pressed()
        msg = ('{0} UP'.format(key)).replace("Key.","")
        print("keyevent",msg)
        #orta_ttyin.pushCommand("keyevent"+msg)
    if key == Key.esc:
        """
        purpose: Stopping listener.
        change condition to 
        
        not os.path.exists('/tmp/HARTS/ortaos/vrootfs/System') 

        for actual use.
        """
        return False

# Collect events until on_release returns False.
with Listener(on_press=on_press,on_release=on_release) as listener:
    listener.join()
