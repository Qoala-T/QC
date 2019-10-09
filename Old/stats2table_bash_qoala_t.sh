#!/bin/bash
path=`/path/to/files`
sleep 1
cd $path
echo "This bash script will create table from ?.stats files"
echo "Written by Jamaan Alghamdi & Dr. Vanessa Sluming"
echo "University of Liverpool"
echo "jamaan.alghamdi@gmail.com"
echo "http://www.easyneuroimaging.com"
echo "20/12/2010

"
free="module load freesurfer/v6"
sleep 1
source $FREESURFER_HOME/SetUpFreeSurfer.sh
sleep 1

export SUBJECTS_DIR=/path/to/file
cd $SUBJECTS_DIR
list="`ls -d */`"
asegstats2table --subjects $list --meas volume --skip --tablefile aseg_stats.txt
aparcstats2table --subjects $list --hemi lh --meas thickness --skip --tablefile aparc_thickness_lh.txt
aparcstats2table --subjects $list --hemi lh --meas area --skip --tablefile aparc_area_lh.txt
aparcstats2table --subjects $list --hemi rh --meas thickness --skip --tablefile aparc_thickness_rh.txt
aparcstats2table --subjects $list --hemi rh --meas area --skip --tablefile aparc_area_rh.txt


#### NOTE: Since stats2table is a python2 script, one might run into errors when using it under python3. ####

# One solution maybe to change line 1 to #!/usr/bin/env python2
# Or by changing lines 21-25 to:
# python2 $FREESURFER_HOME/bin/asegstats2table

# For more information on this issue see the FreeSurfer mailing list:
# https://www.mail-archive.com/freesurfer@nmr.mgh.harvard.edu/msg56465.html
# https://mail.nmr.mgh.harvard.edu/pipermail//freesurfer/2018-August/058208.html
