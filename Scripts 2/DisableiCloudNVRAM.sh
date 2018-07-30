#!/bin/sh

# Delete any previous trace of iCloud settings in NVRAM

sudo nvram -d fmm-computer-name  
sudo nvram -d fmm-mobileme-token-FMM

exit 0
