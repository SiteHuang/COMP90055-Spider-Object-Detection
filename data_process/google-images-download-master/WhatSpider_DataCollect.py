from google_images_download import google_images_download
import os
import glob
import shutil

trainPaths = glob.glob("/Users/huangsite/Desktop/SWIFT_Project/Project/Dataset/Traning Data/*")
testPaths = glob.glob("/Users/huangsite/Desktop/SWIFT_Project/Project/Dataset/Test Data/*")
searchNames = []

for path in trainPaths:
	info = os.path.split(path)
	name = info[1].split(',')
	searchName = name[2] + " spider australia"
	searchNames.append(searchName)

# for searchName in searchNames:
# 	argumnets = {
# 	        "keywords": searchName,
# 	        "limit": 100,
# 	        "print_urls": False
# 	    		}

	# response = google_images_download.googleimagesdownload()
	# response.download(argumnets)


# Move 20 files to test data
count = 0
downloadsPaths = glob.glob("/Users/huangsite/Desktop/PYTHON-Project/Collection/google-images-download-master/downloads/*")
for downloadsPath in downloadsPaths:
	count = 0
	combinePath = os.path.join(downloadsPath,"*")
	insideFiles = glob.glob(combinePath)

	downloadsPathInfo = os.path.split(downloadsPath)
	spiderName = downloadsPathInfo[1][:-17]
	
	for path in testPaths:
		if spiderName in path:
			moveDest = path
			break

	for insideFile in insideFiles:
		shutil.move(insideFile,moveDest)
		count = count +1
		if count == 20:
			break










