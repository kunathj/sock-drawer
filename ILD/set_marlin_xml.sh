#!/bin/bash

###############################################################################
#
#  Adapt a Marlin (xml) steering file to work on the specified input files.
#  The script assumes that the line in the xml file where the (simulated) input
#  files are specified is `input_files_line`.
#  The name of the output file is expected to be in line `output_file_line`.
# 
#  The basic task of this script is to replace these to entries in an xml file
#  with those parameters given to the script.
#  I did not find an occasion yet to use this script and test/adapt it. 
#   
###############################################################################
# Line numbers of lines in template that need to be replaced
input_files_line=11
output_file_line=27

if [[  $# < 3 ]]  ; then
  echo "usage: ./set_marlin_xml.sh steering_file output_file input_files"
  exit
fi

# Get input parameters
steering_file=${1}
output_file=${2}
shift 2
input_files=$@

# Detemine detector model from input file and set according compact file
# -> Get detector parameter line from dumpevent and extract model name
first_input_file=$(echo $input_files | awk "{print $1;}")
detector_model=$(dumpevent ${input_files[0]} 1 | grep " detector :" | rev | cut -d" " -f1 | rev )
if [[ ${detector_model} == "unknown" ]]; then
  compact_file="${lcgeo_DIR}/ILD/compact/${detector_model}/${detector_model}.xml"
else
  compact_file="${lcgeo_DIR}/ILD/compact/${detector_model}/${detector_model}.xml"
fi

# Replace the relevant lines (in decreasing line order to avoid problems 
# caused by added line breaks)
sed -i "${output_file_line}s\.*\ ${output_file} \  " ${steering_file}
sed -i "${input_files_line}s\.*\ ${input_files} \  " ${steering_file}