#!/bin/bash

user=""

while getopts "g:u" Option; do
 case $Option in 
 g) group="$(getent group ${OPTARG} | cut -d : -f 3)" ;;
 u) user="$(id -u)" ;;
 esac
 done

shift $((OPTIND-1))

ug=" --user ${user}:${group}"


#example for running /analysis/BIDS/sub-10311
#we have to do this strange mount, because --participant_label does not work correctly
#this mount guarantees that in the container there is a BIDS directory with only one folder sub-10311, and with the necessary other two files to make it BIDS compatible: .bidsignore and the data_description.json

#example 1:
#docker run -i --rm -v /analysis/BIDS/sub-10311:/mybids/sub-10311:ro -v /analysis/Argyelan/test:/output -v /nethome/amiklos/argyelan@gmail.com/howto/GitHub/hcppipeline_my:/mycoeff:ro -v /usr/local/opt/freesurfer5.3/:/mylicense:ro -v /analysis/BIDS/dataset_description.json:/mybids/dataset_description.json -v /analysis/BIDS/.bidsignore:/mybids/.bidsignore  amiklos/hcppipeline:4.04 --n_cpus 12 --gdcoeffs /mycoeff/coeff.grad --license_key /mylicense/license.txt /mybids /output participant

#example 2 with specific stages:
#docker run -i --rm -v /analysis/BIDS/sub-10311:/mybids/sub-10311:ro -v /analysis/Argyelan/test:/output -v /nethome/amiklos/argyelan@gmail.com/howto/GitHub/hcppipeline_my:/mycoeff:ro -v /usr/local/opt/freesurfer5.3/:/mylicense:ro -v /analysis/BIDS/dataset_description.json:/mybids/dataset_description.json -v /analysis/BIDS/.bidsignore:/mybids/.bidsignore  amiklos/hcppipeline:4.04 --n_cpus 12 --gdcoeffs /mycoeff/coeff.grad --stages fMRIVolume fMRISurface --license_key /mylicense/license.txt /mybids /output participant

#example 3 with ICAFIX
#docker run -it --rm -v /analysis/BIDS/sub-10311:/mybids/sub-10311:ro -v /analysis/Argyelan/test:/output -v /nethome/amiklos/argyelan@gmail.com/howto/GitHub/hcppipeline_my:/mycoeff:ro -v /usr/local/opt/freesurfer5.3/:/mylicense:ro -v /analysis/BIDS/dataset_description.json:/mybids/dataset_description.json -v /analysis/BIDS/.bidsignore:/mybids/.bidsignore  amiklos/hcppipeline:4.10 --n_cpus 12 --gdcoeffs /mycoeff/coeff.grad --stages ICAFIX --license_key /mylicense/license.txt /mybids /output participant 


#solve:/mycoeff/coeff.grad should be in the github as well...

#amiklos/hcppipeline:4:04 is genearted based on argyelan/HCPPIPELINE repository ZHHSpecific branch

#BIDS_DIR=/data/BIDS
BIDS_DIR=/data/BIDS

#docker run -i --rm -v ${BIDS_DIR}/sub-${1}:/mybids/sub-${1}:ro -v ${4}:/output -v ${3}:/mycoeff:ro -v /usr/local/opt/freesurfer5.3/:/mylicense:ro -v ${BIDS_DIR}/dataset_description.json:/mybids/dataset_description.json -v ${BIDS_DIR}/.bidsignore:/mybids/.bidsignore  amiklos/hcppipeline:4.10 --n_cpus 12 --gdcoeffs /mycoeff/coeff.grad --license_key /mylicense/license.txt /mybids /output participant 

#the problem is that it has to run different sessions as completetely independent, the output is little bit weird: session and subject below, but works for now

if [ ! -d ${4}/ses-${2} ]; then
  mkdir ${4}/ses-${2}
fi

#docker run -i --rm -v ${BIDS_DIR}/sub-${1}/ses-${2}:/mybids/sub-${1}/ses-${2}:ro -v ${4}/ses-${2}:/output -v ${3}:/mycoeff:ro -v /usr/local/opt/freesurfer5.3/:/mylicense:ro -v ${BIDS_DIR}/dataset_description.json:/mybids/dataset_description.json -v ${BIDS_DIR}/.bidsignore:/mybids/.bidsignore  amiklos/hcppipeline:4.10 --n_cpus 12 --gdcoeffs /mycoeff/coeff.grad --stages fMRIVolume fMRISurface ICAFIX --license_key /mylicense/license.txt /mybids /output participant 

echo podman run $ug -i --rm -v ${BIDS_DIR}/sub-${1}/ses-${2}:/mybids/sub-${1}/ses-${2}:ro -v ${4}/ses-${2}:/output -v ${3}:/mycoeff:ro -v /usr/local/opt/freesurfer5.3/:/mylicense:ro -v ${BIDS_DIR}/dataset_description.json:/mybids/dataset_description.json -v ${BIDS_DIR}/.bidsignore:/mybids/.bidsignore  amiklos/hcppipeline:4.10 --n_cpus 2 --gdcoeffs /mycoeff/coeff.grad --license_key /mylicense/license.txt /mybids /output participant 

podman run $ug -i --rm -v ${BIDS_DIR}/sub-${1}/ses-${2}:/mybids/sub-${1}/ses-${2}:ro -v ${4}/ses-${2}:/output -v ${3}:/mycoeff:ro -v /usr/local/opt/freesurfer5.3/:/mylicense:ro -v ${BIDS_DIR}/dataset_description.json:/mybids/dataset_description.json -v ${BIDS_DIR}/.bidsignore:/mybids/.bidsignore  amiklos/hcppipeline:4.10 --n_cpus 2 --gdcoeffs /mycoeff/coeff.grad --license_key /mylicense/license.txt /mybids /output participant 
