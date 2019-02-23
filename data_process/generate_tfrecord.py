"""
Usage:
  # From tensorflow/models/
  # Create train data:
  python generate_tfrecord.py --csv_input=data/train_labels.csv  --output_path=train.record

  # Create test data:
  python generate_tfrecord.py --csv_input=data/test_labels.csv  --output_path=test.record
"""
from __future__ import division
from __future__ import print_function
from __future__ import absolute_import

import os
import io
import pandas as pd
import tensorflow as tf

from PIL import Image
from object_detection.utils import dataset_util
from collections import namedtuple, OrderedDict

flags = tf.app.flags
flags.DEFINE_string('csv_input', '/Users/huangsite/Desktop/WhatSpider_Proj/training_trial3/Pre_data/Data_XML_to_CSV/train.csv', 'Path to the CSV input')
flags.DEFINE_string('output_path', '/Users/huangsite/Desktop/WhatSpider_Proj/training_trial3/Pre_data/Data_CSV_to_TFRecord/train.record', 'Path to output TFRecord')
flags.DEFINE_string('image_dir', '/Users/huangsite/Desktop/WhatSpider_Proj/Dataset/all_images ', 'Path to images')
FLAGS = flags.FLAGS


# TO-DO replace this with label map
def class_text_to_int(row_label):
    if row_label == 'Ant-mimicking Spider':
        return 1
    elif row_label == 'Black House Spider':
        return 2
    elif row_label == 'Flower Spider':
        return 3        
    elif row_label == 'Garden Orb-Weaving Spider':
        return 4        
    elif row_label == 'Huntsman Spider':
        return 5
    elif row_label == 'Mouse Spider':
        return 6
    elif row_label == 'Recluse Spider':
        return 7
    elif row_label == 'Redback Spider':
        return 8
    elif row_label == "Saint Andrew\\'s Cross Spider":
        return 9
    elif row_label == 'Spiny Spider':
        return 10
    elif row_label == 'Spitting Spider':
        return 11
    elif row_label == 'Funnel-Web Spider':
        return 12
    elif row_label == 'Tarantula Spider':
        return 13
    elif row_label == 'TrapDoor Spider':
        return 14
    elif row_label == 'White-tailed Spider':
        return 15
    elif row_label == 'Wolf Spider':
        return 16
    elif row_label == 'Yellow Sac Spider':
        return 17
    elif row_label == 'Ant':
        return 18
    elif row_label == 'Crab':
        return 19
    elif row_label == 'Spider man':
        return 20
    else:
        None


def split(df, group):
    data = namedtuple('data', ['filename', 'object'])
    gb = df.groupby(group)
    return [data(filename, gb.get_group(x)) for filename, x in zip(gb.groups.keys(), gb.groups)]


def create_tf_example(group, path):
    with tf.gfile.GFile(os.path.join(path, '{}'.format(group.filename)), 'rb') as fid:
        encoded_jpg = fid.read()
    encoded_jpg_io = io.BytesIO(encoded_jpg)
    image = Image.open(encoded_jpg_io)
    width, height = image.size

    filename = group.filename.encode('utf8')
    # print(filename)
    image_format = b'jpg'
    xmins = []
    xmaxs = []
    ymins = []
    ymaxs = []
    classes_text = []
    classes = []

    for index, row in group.object.iterrows():
        xmins.append(row['xmin'] / width)
        xmaxs.append(row['xmax'] / width)
        ymins.append(row['ymin'] / height)
        ymaxs.append(row['ymax'] / height)
        classes_text.append(row['class'].encode('utf8'))
        classes.append(class_text_to_int(row['class']))
    # print(classes_text)

    tf_example = tf.train.Example(features=tf.train.Features(feature={
        'image/height': dataset_util.int64_feature(height),
        'image/width': dataset_util.int64_feature(width),
        'image/filename': dataset_util.bytes_feature(filename),
        'image/source_id': dataset_util.bytes_feature(filename),
        'image/encoded': dataset_util.bytes_feature(encoded_jpg),
        'image/format': dataset_util.bytes_feature(image_format),
        'image/object/bbox/xmin': dataset_util.float_list_feature(xmins),
        'image/object/bbox/xmax': dataset_util.float_list_feature(xmaxs),
        'image/object/bbox/ymin': dataset_util.float_list_feature(ymins),
        'image/object/bbox/ymax': dataset_util.float_list_feature(ymaxs),
        'image/object/class/text': dataset_util.bytes_list_feature(classes_text),
        'image/object/class/label': dataset_util.int64_list_feature(classes),
    }))
    return tf_example


def main(_):
    writer = tf.python_io.TFRecordWriter(FLAGS.output_path)
    path = os.path.join(FLAGS.image_dir)
    examples = pd.read_csv(FLAGS.csv_input)
    grouped = split(examples, 'filename')
    for group in grouped:
        tf_example = create_tf_example(group, path)
        writer.write(tf_example.SerializeToString())

    writer.close()
    output_path = os.path.join(os.getcwd(), FLAGS.output_path)
    print('Successfully created the TFRecords: {}'.format(output_path))


if __name__ == '__main__':
    tf.app.run()
