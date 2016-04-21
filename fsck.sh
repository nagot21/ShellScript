#!/bin/bash

#Execute fsck on the next system boot

tune2fs -c 20 /dev/sda1
tune2fs -C 20 /dev/sda1
