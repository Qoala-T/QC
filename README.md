## Qoala-T: A supervised-learning tool to assess accuracy of manual quality control of automated neuroanatomical labeling in developmental MRI data

Version 1 14 feb 2018
Qoala-T is developed in the [Brain and development research center](https://www.brainanddevelopmentlab.nl) by [Lara Wierenga](https://www.brainanddevelopmentlab.nl/index.php/people/post-docs/181-post-doctoral-researchers/273-lara-wierenga) and [Eduard Klapwijk](https://www.brainanddevelopmentlab.nl/index.php/people/post-docs/181-post-doctoral-researchers/287-eduard-klapwijk)

About
-----
Qoala-T is a supervised learning tool that asseses accuracy of manual control of automated neuroanatomical labeling of FreeSurfer processed T1 imaging scans. It is particularly suitable for developmental datasets. 
This reproducibility package contains data and R code for the steps 2B and 4 as part of our Qoala-T tool descirbed in Klapwijk et al ., (in prep).  

### Running Qoala-T
- To be able to run Qoala-T, T1 MRI images should be processed in [FreeSurfer V6.0](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall). 
- Next run [stats2table_bash_qoala_t.sh](https://github.com/larawierenga/Qoala-T-under-construction/blob/master/stats2table_bash_qoala_t.sh) to create an input file for the Qoala-T tool. 

### Predicting scan Qoala-T score by rating 10% of your data
Run [Qoala_T_step2_10perc_github.R](https://github.com/larawierenga/Qoala-T-under-construction/blob/master/Qoala_T_step2_10perc_github.R).
In this step an inhouse manual QC protocol can be applied on a subset of the dataset (e.g. 10%, N>100 is recommended for reliable results).  
A flowchart of this process can be observed in step 2B. 
[[Flowchart step 2BFigure1_flowchart_step2.pdf|alt=octocat]]


### Predicting scan Qoala-T score by using Braintime model


Support and communication
-------------------------
If you have any question or suggestion, dont hesitate to get in touch:
<l.m.wierenga@fsw.leidenuniv.nl>


Citation
--------
**When using Qoala-T, please include the following citation:**

Klapwijk, E.T., van de Kamp, F., Meulen, M., Peters, S. and Wierenga, L.M. (in prep) *Qoala-T: A supervised-learning tool to assess accuracy of manual quality control of automated neuroanatomical labeling in developmental MRI data.*


Authors
-------
Eduard T. Klapwijk, Ferdi van de Kamp, Mara van der Meulen, Sabine Peters, and Lara M. Wierenga


Copyright (C) 2017 Lara Wierenga - Leiden University, Brain and Development Research Center
Akk rights reserved.

----


