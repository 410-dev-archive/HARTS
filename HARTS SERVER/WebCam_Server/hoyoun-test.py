import numpy as np
import cv2


def showVideo():
    try:
        print('Turning on Camera')
        cap = cv2.VideoCapture(0)

    except:
        print('Failed to turn on Camera')
        return

    cap.set(3, 480)
    cap.set(4, 320)

    while True:
        ret, frame = cap.read()

        if not ret:
            print('Error Occurred')
            break

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        cv2.imshow('video', gray)

        k = cv2.waitkey(1) & 0xFF
        if k == 27:
            break

    cap.release()
    cv2.destroyAllWindows()


showVideo()