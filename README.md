# ZHHpipelines
The preprocessing pipeline at ZHH
## BIDS Conversion
**Usage: dicom2bids.sh grid_num sess_num descr**
  
  grid_num: subject identifier;
  sess_num: session identifier;
  descr: study specificator (currently available: TMS)

**Usage: multiple_dicom2bids.sh info.csv**

  info.csv: a file with 3 columns, first subject identifier, second: session identifier, third: study type
  Program goes over every line one by one and calls dicom2bids.sh

test 2 ....
## Before we start the pipeline we will implement MARSS as per PMID: 39501896 PMCID: PMC11538719 DOI: 10.1002/hbm.70066
the script is currently: 
'/analysis/Argyelan/MARSS' so path has to be set here, then: 

MARSS('/analysis/Argyelan/temp/sub-[gridno]_ses-[sesno]_task-rest_acq-PA_run-01_bold.nii',8,'/analysis/Argyelan/temp')

where the 1st argument is the functional images from the BIDS func directory (it has to be nii, nii.gz does not work), 8 is set for our site b/c we had acceleration factor 8, and last parameter is output directory
Output will put things into the output directory/sub-[gridno]_ses-[sesno]_task-rest_acq-PA_run-01_bold and from hiere zasub-[gridno]_ses-[sesno]_task-rest_acq-PA_run-01_bold.nii will need to be put into a new BIDS structure as the pipeline has to be run on it.

