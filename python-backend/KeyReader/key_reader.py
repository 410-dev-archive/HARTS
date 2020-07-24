import sys # cache disable
sys.dont_write_bytecode = True

from pynput.keyboard import Key, Listener # $ pip3 install pynput
import orta_ttyin

def on_press(key):
    """
    e.g. len('X') == 3, thus any single character including alphabet or number is eliminated
    from the following commands.
    """
    if len(str(key)) > 3:
        msg = ('{0} DOWN'.format(key))
        msg = msg.replace("Key.","")
        print(msg)
        #orta_ttyin.pushCommand(msg) #send to ortaOS
        
def on_release(key):
    #print('{0} release'.format(key))
    if key == Key.esc:
        """
        purpose: Stopping listener,
        erase for actual use to infinite loop until taskkilled. = daemon thread.
        """
        return False

# Collect events until esc released
with Listener(on_press=on_press,on_release=on_release) as listener:
    listener.join()
