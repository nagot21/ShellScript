#!/bin/bash

#This Script update everyday the hwclock and system clock.

ntpdate-debian
hwclock -w
