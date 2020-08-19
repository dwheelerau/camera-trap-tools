#!/usr/bin/env python
import csv
import json
import sys

# A script to convert megadetector_batch json into CSV
# The CSV cols are: filename, max_confidence, #obj, obj_categories, info

## Note the bbox info is ignored as it is not used in MD training
## The info col contains probs of other detections

DET_THRESHOLD=0.8

def process_detections(detections, threshold):
    """process the list of detections"""
    if len(detections) == 0:
        # no objects detected just pass 0 values through to the CSV
        num_detections = 0
        category = "0"
        info = []
    else:
        cat_found = []
        info = []
        # logic to only summarise info for obj above the threshold
        for detection in detections:
            if detection['conf'] >= threshold:
                # only report it in this group if it is above the thres
                # this will stop weak hits messing things up
                cat_found.append(detection['category'])
            info_string = "%s:%s" % (detection['category'], detection['conf'])
            info.append(info_string)
        num_detections = len(cat_found)
        # remove duplictes and join with /
        category = "/".join(list(set(cat_found)))
        info = str(info).replace(',',';')
    return (num_detections, category, info)

# main processing
infile_json = sys.argv[1]
outfile_csv = infile_json.replace('.json','.csv')

try:
    assert infile_json.find('json') > -1
except AssertionError:
    print("File does not end in json??")
    sys.exit(1)

with open(infile_json) as rf:
    data = json.load(rf)

with open(outfile_csv, 'w') as wf:
    csv_writer = csv.writer(wf)
    for image in data['images']:
        filename = image['file']
        try:
            max_detection_conf = image['max_detection_conf']
            detections = image['detections']
            num_detections, category, info = process_detections(detections,
                    DET_THRESHOLD)
            data = [filename, max_detection_conf, num_detections,
                    category, info]
            csv_writer.writerow(data)
        except KeyError:
            print(image)
