# Training a custom object detection model in Tensorflow and Building an IOS app with Google Cloud Platform
_Object Detection. Swift. Tensorflow. Google Cloud Platform (GCP)_.

A basic front app for detecting Australian spiders. 

<p align="center">
  <img width="400" src="https://github.com/SiteHuang/COMP90055-Spider-Object-Detection/blob/master/images/Picture1.jpg">
</p>

## Data Collection and Preprocess
1. **Data Collection**: _data_process_ folder contains two crawler python file, Flickr image crawler and google image crawler.
1. **Data Notation**: Once got the dataset, draw the bounding box and and get xml file for each of the images using [Labelimg](https://github.com/tzutalin/labelImg) 
1. **Generate Test and Train TFRECORD files**: Split the dataset into two groups, test and train. Modifying and running the _xml_to_csv.py_ in _data_process_ folder to get two CSV files, test.csv and train.csv. And then modifying and running the _generate_tfrecord.py_ as well to get corresponding _.tfrecord_ files.
1. **Create label map** Create a _.pbtxt_ file list all the classes name and format as below:

<p align="center">
  <img width="300" src="https://github.com/SiteHuang/COMP90055-Spider-Object-Detection/blob/master/images/Picture2.png">
</p>

5. **Select a pre-trained model and Modify .config file** Select a pre-trained model from [detection_models](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md) and the corresponding .config file [samples/configs](https://github.com/tensorflow/models/tree/master/research/object_detection/samples/configs). 

## Training
1. Clone the repo [models](https://github.com/tensorflow/models). Put the dataset, _.tfrecord_ files, pre-trained model, label_map.pbtxt and _.config_ file in the folder of **models/research/object_detection/legacy/**. Modify _num_classes_, _train_input_path_, _eval_input_path_ and _label_map_path_ in the _.config_ file.
1. 
