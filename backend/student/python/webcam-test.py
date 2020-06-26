import cv2
import time
import numpy as np

cv2.namedWindow("video")

cap = cv2.VideoCapture(1)
time.sleep(3)

while cv2.waitKey(1)!= 30:
    flag, frame = cap.read()
    cv2.imshow("video", frame)

cap.release()
cv2.destroyAllWindows()
