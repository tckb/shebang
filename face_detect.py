#!/usr/local/bin/python2
import cv2
import sys
import os.path
import numpy as np

print 'detecting face for ' +sys.argv[1]

face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_alt2.xml')
img = cv2.imread(sys.argv[1])
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
gray_hist = cv2.equalizeHist(gray);

faces = face_cascade.detectMultiScale(gray_hist, scaleFactor=1.03 ,minNeighbors=10,minSize=(5,5),flags=cv2.cv.CV_HAAR_SCALE_IMAGE)
# print 'found '+str(len(faces))+' faces'
i=1
for (x,y,w,h) in faces:
	face = img[ y:(y+h), x:(x+w) ]
	resized_image = cv2.resize(face, (100, 100)) 
	# cv2.imshow('face',face)
	# cv2.waitKey(0)
	path=os.path.join(sys.argv[2] ,  'face-' + str(np.random.randint(0,100000000)) + '.jpg')
	# print 'saving at '+path
	cv2.imwrite(path ,resized_image)
	i=i+1
