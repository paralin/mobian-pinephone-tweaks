#!/bin/sh

# Configure camera
media-ctl -d /dev/media0 --set-v4l2 '"ov5640 3-004c":0[fmt:YUYV8_2X8/1280x720]'
media-ctl -d /dev/media0 --set-v4l2 '"gc2145 3-003c":0[fmt:YUYV8_2X8/1280x720]'

# Select back camera
media-ctl -d /dev/media0 --links '"gc2145 3-003c":0->"sun6i-csi":0[0]'
media-ctl -d /dev/media0 --links '"ov5640 3-004c":0->"sun6i-csi":0[1]'
