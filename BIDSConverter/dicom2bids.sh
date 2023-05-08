#!/bin/bash

#CURRENT: we use bidskit docker since it has a much more intuitive (=simpler) wrapper which has to be stored in /derivatives/conversion

#OLD: using nipy/heudiconv which was pulled as latest on 2018-SEP-11
# docker is called with -i (-t cant tolerated by SGEroot, and -d, would not be controlled by SGE)

BIDS=/data/BIDS
TRASH=/data/.BIDSwork
MY_PATH="`dirname \"$0\"`"
MY_FULL_PATH=`readlink -f ${MY_PATH}`

inline_find_session(){
  for study in 3T 611 BAMM BONSAI BORIS certs rTMS FE Clozapine Clozapine-ECT IPER RelapseLAI SGAECT SPINS tACS imagerepo; do
    ls -1d /data/${study}/*${1} 2>/dev/null
  done
}

# We should not need to specify a third parameter for study, because the study can be derived from the session path
sessionpath="$(inline_find_session ${2})"
study="$(echo "${sessionpath}" | cut -d / -f 3)"

case "$study" in
"IPER" | "IPER_SR")
 docker run -i --rm -v ${sessionpath}/dicom/:/input/dicom/${1}/${2}:ro -v ${BIDS}/:/output -v ${MY_FULL_PATH}:/derivatives -v ${TRASH}:/work  amiklos/bidskit:2023.42 --indir=/input/dicom --outdir=/output #--overwrite
 docker run -i --rm -v ${MY_FULL_PATH}:/data -v ${BIDS}:/output --entrypoint=Rscript library/r-base --vanilla /data/configfiles/overwrite_events_Gambling.R ${1} ${2} #/data and /output should be left since it is in the overwrite_events.R 
 docker run -i --rm -v ${MY_FULL_PATH}:/data -v ${BIDS}:/output --entrypoint=Rscript library/r-base --vanilla /data/configfiles/overwrite_events.R ${1} ${2} #/data and /output should be left since it is in the overwrite_events.R 
 ;;
"rTMS")
 docker run -i --rm -v ${sessionpath}/dicom/:/input/dicom/${1}/${2}:ro -v ${BIDS}/:/output -v ${MY_FULL_PATH}:/derivatives -v ${TRASH}:/work  amiklos/bidskit:2023.42 --indir=/input/dicom --outdir=/output #--overwrite
 docker run -i --rm -v ${MY_FULL_PATH}:/data -v ${BIDS}:/output --entrypoint=Rscript library/r-base --vanilla /data/configfiles/overwrite_events.R ${1} ${2} #/data and /output should be left since it is in the overwrite_events.R 
 ;;
 "FE")
 docker run -i --rm -v ${sessionpath}/dicom/:/input/dicom/${1}/${2}:ro -v ${BIDS}/:/output -v ${MY_FULL_PATH}:/derivatives -v ${TRASH}:/work  amiklos/bidskit:2023.42 --indir=/input/dicom --outdir=/output #--overwrite
 docker run -i --rm -v ${MY_FULL_PATH}:/data -v ${BIDS}:/output --entrypoint=Rscript library/r-base --vanilla /data/configfiles/overwrite_events_Gambling.R ${1} ${2} #/data and /output should be left since it is in the overwrite_events.R 
 ;;
"imagerepo")
 docker run -i --rm -v ${sessionpath}/dicom/:/input/dicom/${1}/${2}:ro -v ${BIDS}/:/output -v ${MY_FULL_PATH}:/derivatives -v ${TRASH}:/work  amiklos/bidskit:2023.42 --indir=/input/dicom --outdir=/output #--overwrite
 docker run -i --rm -v ${MY_FULL_PATH}:/data -v ${BIDS}:/output --entrypoint=Rscript library/r-base --vanilla /data/configfiles/overwrite_events_auditory.R ${1} ${2} #/data and /output should be left since it is in the overwrite_events.R 
 ;;
"BAMM" | "BONSAI" | "BORIS" | "certs" | "Clozapine" | "Clozapine_CAMH" | "Clozapine-ECT")

 echo "Running docker run -i --rm -v ${sessionpath}/dicom/:/input/dicom/${1}/${2}:ro -v ${BIDS}/:/output -v ${MY_FULL_PATH}:/derivatives -v ${TRASH}:/work  amiklos/bidskit:2023.42 --indir=/input/dicom --outdir=/output"

 docker run -i --rm -v ${sessionpath}/dicom/:/input/dicom/${1}/${2}:ro -v ${BIDS}/:/output -v ${MY_FULL_PATH}:/derivatives -v ${TRASH}:/work  amiklos/bidskit:2023.42 --indir=/input/dicom --outdir=/output #--overwritedocker run -i --rm -v ${sessionpath}/dicom/:/input/dicom/${1}/${2}:ro -v ${BIDS}/:/output -v ${MY_FULL_PATH}:/derivatives -v ${TRASH}:/work  amiklos/bidskit:2023.42 --indir=/input/dicom --outdir=/output #--overwrite
 ;;
"RelapseLAI" | "modsoccs" | "tACS" | "SGAECT")
 docker run -i --rm -v ${sessionpath}/dicom/:/input/dicom/${1}/${2}:ro -v ${BIDS}/:/output -v ${MY_FULL_PATH}:/derivatives -v ${TRASH}:/work  amiklos/bidskit:2023.42 --indir=/input/dicom --outdir=/output #--overwrite
 ;;
esac
