# Training a custom object detection model in Tensorflow and Building an IOS app with Google Cloud Platform
_Object Detection. Swift. Tensorflow. Google Cloud Platform (GCP)_.

A basic front app for detecting Australian spiders. 

<p align="center">
  <img width="400" src="https://github.com/SiteHuang/COMP90055-Spider-Object-Detection/blob/master/images/Picture1.jpg">
</p>

## Data Collection and Preprocess
1. **Data Collection**: _data_process_ folder contains two crawler python file, Flickr image crawler and google image crawler.
1. **Data Notation**: Once got the dataset, draw the bounding box and and get xml file for each of the images using [Labelimg](https://github.com/tzutalin/labelImg) 
1. **Generate Test and Train TFRECORD files**: Split the dataset into two groups, test and train. Modifying and running the _xml_to_csv.py_ in _data_process_ folder to get two CSV files, test.csv and train.csv. And then modifying and running the _generate_tfrecord.py_ as well to get tfrecord files.
