<p align="center"> 
<img src="https://github.com/Qoala-T/QC/blob/master/Figures/KoalaFramework-Logo%20copy%202.jpg" width="25%" height="25%"> 
</p> 

# Qoala-T
  
### *A supervised-learning tool for quality control of FreeSurfer segmented MRI data*
 
 [![Version](https://img.shields.io/badge/version-1.2.1-blue)](https://github.com/Qoala-T/QC/releases)
 [![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://github.com/Qoala-T/QC/blob/master/LICENSE)
 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4575464.svg)](https://doi.org/10.5281/zenodo.4575464)
 
Version 1.2  > prediction model was updated January 14 2019; Github pages updated March 16 2021 <br />
Qoala-T is developed and created by [Lara Wierenga, PhD](https://brainanddevelopment.nl/people/lara-wierenga/) and [Eduard Klapwijk, PhD](https://orcid.org/0000-0002-8936-0365) in the [Brain and development research center](https://www.brainanddevelopment.nl).
<br />

## About

Qoala-T is a supervised learning tool that asseses accuracy of manual quality control of T1 imaging scans and their automated neuroanatomical labeling processed in FreeSurfer. It is particularly intended to use in developmental datasets. 
This package contains data and R code as described in Klapwijk et al., (2019) see [https://doi.org/10.1016/j.neuroimage.2019.01.014](https://doi.org/10.1016/j.neuroimage.2019.01.014). The protocol of our in house developed manual QC procedure can be found [here](https://github.com/Qoala-T/QC/blob/master/Qoala-T_ManualQC.pdf).

We have also developed an app using R Shiny by which the Qoala-T model can be run without having R installed, see the [Qoala-T app](https://qoala-t.shinyapps.io/qoala-t_app/) (source code to run locally can be found [here](https://github.com/Qoala-T/QC/blob/master/Shiny/app.R)).

## Running Qoala-T

- To be able to run the Qoala-T model, T1 MRI images should be processed in [FreeSurfer](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall). The models used in the present version are developped for FreeSurfer V6.0. We have tested this for version FreeSrufer V7.1.0 as well, see more details [below](#validation-of-qoala-t-tool-in-freesurfer-version-7.1.0).  
- Use the following script to extract the necessary information needed in order to perform Qoala-T: for FreeSurfer v6.0 use [Stats2Table.R](https://github.com/Qoala-T/QC/blob/master/Scripts/Stats2Table/Stats2Table.R) for FreeSurfer v7.1.1 use [Stats2Table_fs7.R](https://github.com/Qoala-T/QC/blob/master/Scripts/Stats2Table/Stats2Table_fs7.R)

*Note*: the Stats2Table.R script replaces extraction of necessary txt files using the [fswiki](https://surfer.nmr.mgh.harvard.edu/fswiki/freesurferstats2table) script or [stats2table_bash_qoala_t.sh](https://github.com/Qoala-T/QC/blob/master/Old/stats2table_bash_qoala_t.sh), which had to be merged using [this R script](https://github.com/Qoala-T/QC/blob/master/Old/Qoala_T_merge_example_script.R).


### A. Predicting scan Qoala-T score by using Braintime model (FreeSurfer v6.0)
- With this R script Qoala-T scores for a dataset are estimated using a supervised- learning model. This model is based on 784 T1-weighted imaging scans of subjects aged between 8 and 25 years old (53% females). The manual quality assessment is described in the Qoala-T manual [Manual quality control procedure for structural T1 scans](https://github.com/Qoala-T/QC/blob/master/Qoala-T_Manual.pdf), also available in the supplemental material of Klapwijk et al. (2019).
- To run the model-based Qoala-T option open [Qoala_T_A_model_based_github.R](https://github.com/Qoala-T/QC/blob/master/Scripts/Qoala-T_Scripts/Qoala_T_A_model_based_github.R) and follow the instructions. Alternatively you can run this option without having R installed, see the [Qoala-T app](https://qoala-t.shinyapps.io/qoala-t_app/) (source code [here](https://github.com/Qoala-T/QC/blob/master/Shiny/app.R)).

- An example output table (left) and output graph (right) showing the Qoala-T score of each scan are displayed below. The figure shows the number of included and excluded predictions. The grey area represents the scans that are recommended for manual quality assesment. <br /> <br /> 

<p align="center"> 
<img src="https://github.com/Qoala-T/QC/blob/master/Figures/Qoala_T_table_simulated_data2.png" width="40%" height="50%"> 

<img src="https://github.com/Qoala-T/QC/blob/master/Figures/Figure_Rating_model_based_simulated%20data.jpg" width="45%" height="50%"> 

</p>

#### Run Qoala-T in a Jupyter notebook (FreeSurfer v6.0):
- **NEW**: Using this [Qoala-T Jupyter Notebook](https://github.com/Qoala-T/QC/blob/master/Notebooks/Qoala-T_Notebook.ipynb) is  the easiest way to get from your directory with FreeSurfer-processed data to Qoala-T predictions based on the BrainTime model. Only prerequisite is you can run Jupyter Notebooks in R, for example by installing [Anaconda](https://www.anaconda.com/distribution/) and then follow [these instructions](https://docs.anaconda.com/anaconda/navigator/tutorials/r-lang/). 

### B. Predicting scan Qoala-T score by rating a subset of your data (FreeSurfer v6.0 and FreeSurfer v7.1.0)
- With this R script an in-house developed manual QC protocol can be applied on a subset of the dataset (e.g. 10%, the larger the set, the more reliable the results).  
- To run the subset-based Qoala-T option open [Qoala_T_B_subset_based_github.R](https://github.com/Qoala-T/QC/blob/master/Scripts/Qoala-T_Scripts/Qoala_T_B_subset_based_github.R) and follow the instructions.<br /> <br />
A flowchart of these processes can be observed in A and B below. <br /> 
![FlowChart](https://github.com/Qoala-T/QC/blob/master/Figures/Flowchart_github.jpg "FlowChart")
#### Run Qoala-T subset based in a Jupyter notebook (FreeSurfer v6.0 and FreeSurfer v7.1.0):
- **NEW**: Using this [Qoala-T Jupyter Notebook - subset-based](https://github.com/Qoala-T/QC/blob/master/Notebooks/Qoala-T_Notebook_subset.ipynb) is  the easiest way to get from your directory with FreeSurfer-processed data to Qoala-T predictions onde you have manually rated a subset of your data. Only prerequisite is you can run Jupyter Notebooks in R, for example by installing [Anaconda](https://www.anaconda.com/distribution/) and then follow [these instructions](https://docs.anaconda.com/anaconda/navigator/tutorials/r-lang/). 

### Using Qoala-T with longitudinal data
- When using Qoala-T within the [longitudinal FreeSurfer stream](https://surfer.nmr.mgh.harvard.edu/fswiki/LongitudinalProcessing), the QC predictions should be run within the first step of the processing pipeline (Step 1. the cross-sectional processing of the timepoints). It will not work with the output from the longitudinal stream, since the longitudinal processing does not provide the number of surface holes, which is needed for prediction. 
- When running Qoala-T right after cross-sectional processing, bad quality scans/segmentations can be removed before running step 2 where the template from all time points is created. In this way the template will not be affected by a poor quality timepoint.

## Predictive accuracies in new datasets

In order to continuously evaluate the performance of the Qoala-T tool, we will report predictive accuracies for different datasets on this page. We invite researchers who performed both manual QC and used Qoala-T to share their performance metrics and some basic information about their sample. This can be done by creating a pull request for this Github page or by e-mailing to [e.klapwijk@essb.eur.nl](mailto:e.klapwijk@essb.eur.nl).
The table below reports predictive accuracies in new datasets when using the BrainTime model (i.e., option A that can be run using the Shiny app).

<table class="tg">
  <tr>
    <th class="tg-ejl1" colspan="9"><sub>General information</sub></th>
    <th class="tg-ejl1" colspan="6"><sub>Qoala-T predictions</sub></th>
  </tr>
  <tr>
    <th class="tg-aodl"><sub>Sample name or lab name</sub></th>
    <th class="tg-aodl"><sub>Institute</sub></th>
    <th class="tg-aodl"><sub>Author name(s)</sub></th>
    <th class="tg-aodl"><sub>Group characteristics (e.g., developmental, patient group, elderly)</sub></th>
    <th class="tg-aodl"><sub>Total N</sub></th>
    <th class="tg-aodl"><sub>Age range (years)</sub></th>
    <th class="tg-aodl"><sub>Field strength</sub></th>
    <th class="tg-aodl"><sub>T1  sequence type (e.g., MPRAGE, T13D), field of view, dimensions of voxels</sub></th>
    <th class="tg-aodl"><sub>doi</sub></th>
    <th class="tg-aodl"><sub>Qoala-T version used (current = v1.2)</sub></th>
    <th class="tg-aodl"><sub>Accuracy</sub></th>
    <th class="tg-aodl"><sub>Specificity</sub></th>
    <th class="tg-aodl"><sub>Sensitivity</sub></th>
    <th class="tg-aodl"><sub>Manual QC protocol used (e.g., Qoala-T protocol, in-house)</sub></th>
    <th class="tg-aodl"><sub>Manual QC distribution (i.e., N per quality category)</sub></th>
  </tr>
  <tr>
    <td class="tg-7p3h"><sub>BESD</sub></td>
    <td class="tg-7p3h"><sub>Leiden University</sub></td>
    <td class="tg-7p3h"><sub>Moji Aghajani, Eduard Klapwijk et al.</sub></td>
    <td class="tg-7p3h"><sub>Adolescents with conduct disorder, autism spectrum disorder, and typically developing</sub></td>
    <td class="tg-7p3h"><sub>112</sub></td>
    <td class="tg-7p3h"><sub>15-19</sub></td>
    <td class="tg-7p3h"><sub>3T</sub></td>
    <td class="tg-7p3h"><sub>T1 3D, FOV 224x177x168, voxel size 0.875 x 0.875 x 1.2 mm</sub></td>
    <td class="tg-7p3h"><sub>https://doi.org/10.1111/jcpp.12498; https://doi.org/10.1016/j.biopsych.2016.05.017</sub></td>
    <td class="tg-7p3h"><sub>v1.2</sub></td>
    <td class="tg-7p3h"><sub>0.893</sub></td>
    <td class="tg-7p3h"><sub>0.978</sub></td>
    <td class="tg-7p3h"><sub>0.524</sub></td>
    <td class="tg-7p3h"><sub>Qoala-T protocol</sub></td>
    <td class="tg-7p3h"><sub>excellent=19, good=51, doubtful=21, failed=21</sub></td>
  </tr>
  <tr>
    <td class="tg-7p3h"><sub>ABIDE (subset)</sub></td>
    <td class="tg-7p3h"><sub>NITRC</sub></td>
    <td class="tg-7p3h"><sub>Di Martino et al.</sub></td>
    <td class="tg-7p3h"><sub>autism spectrum disorders, typically developing controls</sub></td>
    <td class="tg-7p3h"><sub>760</sub></td>
    <td class="tg-7p3h"><sub>6-39</sub></td>
    <td class="tg-7p3h"><sub>3T</sub></td>
    <td class="tg-7p3h"><sub>site-specific, see http://fcon_1000.projects.nitrc.org/indi/abide/abide_I.html</sub></td>
    <td class="tg-7p3h"><sub>https://doi.org/10.1038/mp.2013.78</sub></td>
    <td class="tg-7p3h"><sub>v1.2</sub></td>
    <td class="tg-7p3h"><sub>0.809</sub></td>
    <td class="tg-7p3h"><sub>0.815</sub></td>
    <td class="tg-7p3h"><sub>0.783</sub></td>
    <td class="tg-7p3h"><sub>from MRIQC project: T1 images were rated aided by FreeSurfer surface reconstructions</sub></td>
    <td class="tg-7p3h"><sub>good/accept=608, doubtful=14, failed/exclude=138</sub></td>
  </tr>
  <tr>
    <td class="tg-7p3h"><sub>MCN Basel</sub></td>
    <td class="tg-7p3h"><sub>University of Basel</sub></td>
    <td class="tg-7p3h"><sub>David Coynel</sub></td>
    <td class="tg-7p3h"><sub>healthy young adults</sub></td>
    <td class="tg-7p3h"><sub>1773</sub></td>
    <td class="tg-7p3h"><sub>18-35</sub></td>
    <td class="tg-7p3h"><sub>3T</sub></td>
    <td class="tg-7p3h"><sub>MPRAGE, 256x256x176, 1mm3</sub></td>
    <td class="tg-7p3h"><sub>http://dx.doi.org/10.1523/ENEURO.0222-17.2018</sub></td>
    <td class="tg-7p3h"><sub>v1.1</sub></td>
    <td class="tg-7p3h"><sub>0.963</sub></td>
    <td class="tg-7p3h"><sub>0.985</sub></td>
    <td class="tg-7p3h"><sub>0.524</sub></td>
    <td class="tg-7p3h"><sub>in-house visual inspection of raw data</sub></td>
    <td class="tg-7p3h"><sub>good/excellent: N=1691; doubtful/bad: N=82</sub></td>
  </tr>
</table>

## Validation of Qoala-T tool in FreeSurfer version 7.1.0 

We have assessed the preformance of the Qoala-T tool on the latest FreeSurfer v7.1.0 release. We have tested this using a 10 fold cross validation to see if we could replicate the results of FreeSurfer v6.0 as published in paragraph 3.3 of [Klapwijk et al., (2019)](https://doi.org/10.1016/j.neuroimage.2019.01.014). Results are highly similar, yet sensitivity is a little lower and shows larger variation. This indicates that FreeSurfer vs7.1.0 gives more conservative results, as some good scans might be flagged as manual check or poor quality. 
Note that the random forest model paramaters were identical to the ones used in the publication of Klapwijk et al. (2019). In addition, we used the manual quality ratings based on the v6.0 output. So potentially the accuracy of the segmentatios between the two FreeSurfer versions may differ, which we did not assess here. We would recommand to use the subset-based Qoala-T option for data processed in FreeSurfer v7.1.0 [Qoala_T_B_subset_based_github.R](https://github.com/Qoala-T/QC/blob/master/Scripts/Qoala-T_Scripts/Qoala_T_B_subset_based_github.R) rather than the model based Qoala-T option (based on FreeSurfer v6.0 segmentations). 

|Fold | AUC | Accuracy |Sensitivity |Specificity |
| ---| --- | --- |--- |--- |
|1 |	0.977|	0.976|	0.806|	0.985|
|2 |	0.989|	0.976|	0.871|	0.982|
|3 |	0.974|	0.970|	0.750|	0.982|
|4 |	0.970|	0.975|	0.813|	0.983|
|5 |	0.968|	0.971|	0.710|	0.985|
|6 |	0.980|	0.970|	0.906|	0.973|
|7 |	0.980|	0.976|	0.935|	0.978|
|8 |	0.971|	0.973|	0.844|	0.980|
|9 |	0.967|	0.973|	0.813|	0.982|
|10|	0.973|	0.973|	0.871|  0.978|
|**Mean** | 0.975 | 0.973 | 0.832 | 0.981|
|**SD**	| 0.007 | 0.002	| 0.069 | 0.004|



## Support and communication

If you have any question or suggestion don't hesitate to get in touch. Please leave a message at the [Issues page](https://github.com/Qoala-T/QC/issues).


## Citation

**When using Qoala-T please include the following citation:**

Klapwijk, E.T., van de Kamp, F., van der Meulen, M., Peters, S. and Wierenga, L.M. (2019). Qoala-T: A supervised-learning tool for quality control of FreeSurfer segmented MRI data. *NeuroImage, 189*, 116-129. https://doi.org/10.1016/j.neuroimage.2019.01.014


## Authors

Eduard T. Klapwijk, Ferdi van de Kamp, Mara van der Meulen, Sabine Peters, and Lara M. Wierenga

