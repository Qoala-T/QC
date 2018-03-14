<p align="center"> 
<img src="https://github.com/larawierenga/Qoala-T-under-construction/blob/master/Figures/KoalaFramework-Logo%20copy%202.jpg" width="25%" height="25%"> 
</p> 

# Qoala-T
  
### *A supervised-learning tool to assess accuracy of manual quality control of automatic segmented MRI data*

Version (1)   updated March 14 2018 <br />
Qoala-T is developed in the [Brain and development research center](https://www.brainanddevelopmentlab.nl) by [Lara Wierenga, PhD](https://www.brainanddevelopmentlab.nl/index.php/people/post-docs/181-post-doctoral-researchers/273-lara-wierenga) and [Eduard Klapwijk, PhD](https://www.brainanddevelopmentlab.nl/index.php/people/post-docs/181-post-doctoral-researchers/287-eduard-klapwijk)
<br />

About
-----
Qoala-T is a supervised learning tool that asseses accuracy of manual quality control of T1 imaging scans and their automated neuroanatomical labeling processed in FreeSurfer. It is particularly intended to use in developmental datasets. 
This package contains data and R code as described in Klapwijk et al., (in prep). The protocol of our in house developped manual QC procedure can be found [here](https://github.com/larawierenga/Qoala-T/blob/master/Github_Qoala-T_Manual_QC.pdf).  

### Running Qoala-T
- To be able to run the Qoala-T model, T1 MRI images should be processed in [FreeSurfer V6.0](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall). 
- Next run [stats2table_bash_qoala_t.sh](https://github.com/larawierenga/Qoala-T/blob/master/stats2table_bash_qoala_t.sh), an adapted version from [fswiki](https://surfer.nmr.mgh.harvard.edu/fswiki/freesurferstats2table). To create an input file for the Qoala-T tool merge these files into one (see [example R script](https://github.com/larawierenga/Qoala-T/blob/master/Qoala_T_merge_example_script.R)). 



### A. Predicting scan Qoala-T score by using Braintime model
- Open [Qoala_T_A_model_based_github.R](https://github.com/larawierenga/Qoala-T/blob/master/Qoala_T_A_model_based_github.R) and follow the instructions.
- With this R script Qoala-T scores for a dataset are estimated using a supervised- learning model. This model is based on 784 T1-weighted imaging scans of subjects aged between 8 and 25 years old (53% females). The manual quality assessment is described in the Qoala-T manual [Manual quality control procedure for structural T1 scans](https://github.com/larawierenga/Qoala-T/blob/master/Qoala_T_Manual.pdf), also available in the supplemental material of Klapwijk et al., (in prep).
- An example output table (left) and output graph (right) showing the Qoala-T score of each scan are displayed below. The figure shows the number of included and excluded predictions. The grey area represents the scans that are recommended for manual quality assesment. <br /> <br /> 

<p align="center"> 
<img src="https://github.com/larawierenga/Qoala-T/blob/master/Figures/Qoala_T_table_simulated_data2.png" width="40%" height="50%"> 

<img src="https://github.com/larawierenga/Qoala-T/blob/master/Figures/Figure_Rating_model_based_simulated%20data.jpg" width="45%" height="50%"> 

</p>

### B. Predicting scan Qoala-T score by rating 10% of your data
- Open [Qoala_T_B_subset_based_github.R](https://github.com/larawierenga/Qoala-T/blob/master/Qoala_T_B_subset_based_github.R) and follow the instructions.
- With this R script an in-house developed manual QC protocol can be applied on a subset of the dataset (e.g. 10%, the larger the set, the more reliable the results).  <br /> <br />
A flowchart of these processes can be observed in A and B below. <br /> 
![FlowChart](https://github.com/larawierenga/Qoala-T/blob/master/Figures/Flowchart_github.jpg "FlowChart")

Support and communication
-------------------------
If you have any question or suggestion don't hesitate to get in touch:
<l.m.wierenga@fsw.leidenuniv.nl> or <e.t.klapwijk@fsw.leidenuniv.nl>


Citation
--------
**When using Qoala-T please include the following citation:**

Klapwijk, E.T., van de Kamp, F., Meulen, M., Peters, S. and Wierenga, L.M. (in prep). *Qoala-T: A supervised-learning tool to assess accuracy of manual quality control of automated neuroanatomical labeling in developmental MRI data.*


Authors
-------
Eduard T. Klapwijk, Ferdi van de Kamp, Mara van der Meulen, Sabine Peters, and Lara M. Wierenga

<br />
<br />
Copyright (C) 2017 Lara Wierenga - Leiden University, Brain and Development Research Center<br />
All rights reserved

----


