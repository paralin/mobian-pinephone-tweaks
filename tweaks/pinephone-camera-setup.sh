#!/bin/sh

# Configure camera
media-ctl -d /dev/media0 --set-v4l2 '"ov5640 3-004c":0[fmt:YUYV8_2X8/1280x720]'
