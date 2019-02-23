
"""
 AUTHOR : Xiaolu Zhang
 PURPOSE : To collect cat images from Flickr and Google
"""

import os
import sys
from datetime import date
from icrawler.builtin import FlickrImageCrawler
from icrawler.builtin import GoogleImageCrawler

image_path = '/Users/huangsite/Desktop/ImageCollection/result'
API_KEY = '13ef101ff4bac39647acb5531d8d0a3c'

CatBreedList = open('List1.txt','rt')

for nameList in CatBreedList:
    name = nameList.strip('\n')
    imageDir = image_path + '/' + name
    searchName = name
    flickr_crawler = FlickrImageCrawler(API_KEY, storage={'root_dir': imageDir})
    flickr_crawler.crawl(max_num = 100, tags = searchName, text = searchName)
    # google_crawler = GoogleImageCrawler(storage={'root_dir': imageDir})
    # google_crawler.crawl(keyword=searchName, max_num=1000)

print("Collection is done")
