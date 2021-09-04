#!/bin/sh


module load gcc cuda Anaconda3 jdk
source activate powerai16_ibm
#source activate pytf_cc
time python train_main2_jy.py

