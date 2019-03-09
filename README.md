# Training a custom object detection model in Tensorflow and Building an IOS app with Google Cloud Platform
_Object Detection. Swift. Tensorflow. Google Cloud Platform (GCP)_.

A basic front app for detecting Australian spiders. 

<p align="center">
  <img width="400" src="https://github.com/SiteHuang/COMP90055-Spider-Object-Detection/blob/master/images/Picture1.jpg">
</p>

## Data Collection and Preprocess
1. **Data Collection**: _data_process_ folder contains two crawler python file, Flickr image crawler and google image crawler.
1. **Data Notation**: Once got the dataset, draw the bounding box and and get xml file for each of the images using [Labelimg](https://github.com/tzutalin/labelImg).
1. **Generate Test and Train TFRECORD files**: Split the dataset into two groups, test and train. Modifying and running the _xml_to_csv.py_ in _data_process_ folder to get two CSV files, test.csv and train.csv. And then modifying and running the _generate_tfrecord.py_ as well to get corresponding _.record_ files.
1. **Create label map** Create a _.pbtxt_ file list all the classes name and format as below:

<p align="center">
  <img width="300" src="https://github.com/SiteHuang/COMP90055-Spider-Object-Detection/blob/master/images/Picture2.png">
</p>

5. **Select a pre-trained model and Modify .config file** Select a pre-trained model from [detection_models](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md) and the corresponding .config file [samples/configs](https://github.com/tensorflow/models/tree/master/research/object_detection/samples/configs). 

## Training
1. Clone the repo [models](https://github.com/tensorflow/models). Put the dataset, _.tfrecord_ files, pre-trained model, and training/(_label_map.pbtxt_ and _.config_) in the folder of **models/research/object_detection/legacy/**. Modify _num_classes_, _train_input_path_, _eval_input_path_ and _label_map_path_ in the _.config_ file.
1. Start training:
```
python train.py --logtostderr --train_dir=YOURPATH/training/ --pipeline_config_path=YOURPATH/ssd_mobilenet_v1_pets.config
```

## Export Model
Running the export_inference_graph.py in the foler of models/research/object_detection:
```
python export_inference_graph.py \
    --input_type encoded_image_string_tensor \
    --pipeline_config_path /YOURPATH/pipeline.config \
    --trained_checkpoint_prefix /YOURPATH/model.ckpt-YOUR_CHECKPOINT \
    --output_directory /YOUR_OUTPUT_PATH/
```
    
## Setup Google Cloud Platform
### Create a new project in [GCP](https://console.cloud.google.com)
Create a folder **model/** in the storage of GCP. Put the _**saved_model.pb**_ file from previously exported model path into the **model/** directory.

### Deply model in GCloud
1. Follow the instructions and install the gcloud command [here](https://cloud.google.com/storage/docs/gsutil_install#mac)
2. Create a gcloud ml-engine model: ```gcloud ml-engine models create MODEL_NAME```
3. Show the models list: ```gcloud ml-engine models list```
4. Deploy the model: 
```
gcloud ml-engine versions create v1 --model=MODEL_NAME --origin=gs://BUCKET_NAME/model --runtime-version=1.12(tensorflow_running_version)
```

## Setup [Firebase](https://firebase.google.com/) project 
Setup firebase project linking to your GCP project. And follow the instructions to connect the firebase with your IOS project.

## Deploy Cloud Function
1. Install [nvm](https://github.com/creationix/nvm/blob/master/README.md) 
1. Install [Firebase CLI](https://firebase.google.com/docs/cli/)
1. Run ```npm install``` from the **/firebase/functions/** directory.
1. Update the params in _index.js_ file with the name of your Cloud project and ML Engine model.
1. Run ```firebase deploy --only functions```
1. Once deployed successfully, you can found a cloud function created in the GCP.

## Test Cloud Function
1. Create a images/ directory in the storage. 
1. Upload a test image to images/ directory.
1. If successful, the results of prediction id and confidence will be saved in the Firebase database and the outlined image will be stored in outline_img/ in the storage.
<p align="center">
  <img width="800" src="https://github.com/SiteHuang/COMP90055-Spider-Object-Detection/blob/master/images/Picture3.png">
</p>









