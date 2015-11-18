#!/bin/bash

for application in /root/mezuro/scripts/*/ ; do
  bash $application/run.sh
done