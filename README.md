<p align="center"> 
<img src="https://github.com/Qoala-T/QC/blob/master/Figures/KoalaFramework-Logo%20copy%202.jpg" width="25%" height="25%"> 
</p> 

# Qoala-T
  
### *A supervised-learning tool for quality control of FreeSurfer segmented MRI data*
 
 [![Version](https://img.shields.io/badge/version-1.2-blue)](https://github.com/Qoala-T/QC)
 [![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://github.com/Qoala-T/QC/blob/master/LICENSE)
 
Version 1.2   updated January 14 2019 <br />
Qoala-T is developed and created by [Lara Wierenga, PhD](https://brainanddevelopment.nl/people/lara-wierenga/) and modified by [Eduard Klapwijk, PhD](https://brainanddevelopment.nl/people/eduard-klapwijk/) in the [Brain and development research center](https://www.brainanddevelopment.nl).
<br />

## About

Qoala-T is a supervised learning tool that asseses accuracy of manual quality control of T1 imaging scans and their automated neuroanatomical labeling processed in FreeSurfer. It is particularly intended to use in developmental datasets. 
This package contains data and R code as described in Klapwijk et al., (2019) see [https://doi.org/10.1016/j.neuroimage.2019.01.014](https://doi.org/10.1016/j.neuroimage.2019.01.014). The protocol of our in house developed manual QC procedure can be found [here](https://github.com/Qoala-T/QC/blob/master/Qoala-T_ManualQC.pdf).

We have also developed an app using R Shiny by which the Qoala-T model can be run without having R installed, see the [Qoala-T app](https://qoala-t.shinyapps.io/qoala-t_app/).

## Running Qoala-T

- To be able to run the Qoala-T model, T1 MRI images should be processed in [FreeSurfer V6.0](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall). 
- Use the following script to extract the necessary information needed in order to perform Qoala-T: [Stats2Table.R](https://github.com/Qoala-T/QC/blob/master/Scripts/Stats2Table/Stats2Table.R)

*Note*: Stats2Table.R replaces extraction of necessary txt files using the [fswiki](https://surfer.nmr.mgh.harvard.edu/fswiki/freesurferstats2table) script or [stats2table_bash_qoala_t.sh](https://github.com/Qoala-T/QC/blob/master/Old/stats2table_bash_qoala_t.sh), which had to be merged using [this R script](https://github.com/Qoala-T/QC/blob/master/Old/Qoala_T_merge_example_script.R).


### A. Predicting scan Qoala-T score by using Braintime model
- With this R script Qoala-T scores for a dataset are estimated using a supervised- learning model. This model is based on 784 T1-weighted imaging scans of subjects aged between 8 and 25 years old (53% females). The manual quality assessment is described in the Qoala-T manual [Manual quality control procedure for structural T1 scans](https://github.com/Qoala-T/QC/blob/master/Qoala-T_Manual.pdf), also available in the supplemental material of Klapwijk et al., (2019).
- To run the model-based Qoala-T option open [Qoala_T_A_model_based_github.R](https://github.com/Qoala-T/QC/blob/master/Scripts/Qoala-T_Scripts/Qoala_T_A_model_based_github.R) and follow the instructions. Alternatively you can run this option without having R installed, see the [Qoala-T app](https://qoala-t.shinyapps.io/qoala-t_app/).

- An example output table (left) and output graph (right) showing the Qoala-T score of each scan are displayed below. The figure shows the number of included and excluded predictions. The grey area represents the scans that are recommended for manual quality assesment. <br /> <br /> 

<p align="center"> 
<img src="https://github.com/Qoala-T/QC/blob/master/Figures/Qoala_T_table_simulated_data2.png" width="40%" height="50%"> 

<img src="https://github.com/Qoala-T/QC/blob/master/Figures/Figure_Rating_model_based_simulated%20data.jpg" width="45%" height="50%"> 

</p>

#### Run Qoala-T in a Jupyter notebook:
- **NEW**: Using this [Qoala-T Jupyter Notebook](https://github.com/Qoala-T/QC/blob/master/Notebooks/Qoala-T_Notebook.ipynb) is  the easiest way to get from your directory with FreeSurfer-processed data to Qoala-T predictions based on the BrainTime model. Only prerequisite is you can run Jupyter Notebooks in R, for example by installing [Anaconda](https://www.anaconda.com/distribution/) and then follow [these instructions](https://docs.anaconda.com/anaconda/navigator/tutorials/r-lang/). 

### B. Predicting scan Qoala-T score by rating a subset of your data
- With this R script an in-house developed manual QC protocol can be applied on a subset of the dataset (e.g. 10%, the larger the set, the more reliable the results).  
- To run the subset-based Qoala-T option open [Qoala_T_B_subset_based_github.R](https://github.com/Qoala-T/QC/blob/master/Scripts/Qoala-T_Scripts/Qoala_T_B_subset_based_github.R) and follow the instructions.<br /> <br />
A flowchart of these processes can be observed in A and B below. <br /> 
![FlowChart](https://github.com/Qoala-T/QC/blob/master/Figures/Flowchart_github.jpg "FlowChart")

### Using Qoala-T with longitudinal data
- When using Qoala-T within the [longitudinal FreeSurfer stream](https://surfer.nmr.mgh.harvard.edu/fswiki/LongitudinalProcessing), the QC predictions should be run within the first step of the processing pipeline (Step 1. the cross-sectional processing of the timepoints). It will not work with the output from the longitudinal stream, since the longitudinal processing does not provide the number of surface holes, which is needed for prediction. 
- When running Qoala-T right after cross-sectional processing, bad quality scans/segmentations can be removed before running step 2 where the template from all time points is created. In this way the template will not be affected by a poor quality timepoint.

## Predictive accuracies in new datasets

In order to continuously evaluate the performance of the Qoala-T tool, we will report predictive accuracies for different datasets on this page. We invite researchers who performed both manual QC and used Qoala-T to share their performance metrics and some basic information about their sample. This can be done by creating a pull request for this Github page or by e-mailing to [e.t.klapwijk@fsw.leidenuniv.nl](mailto:e.t.klapwijk@fsw.leidenuniv.nl).
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

## Support and communication

If you have any question or suggestion don't hesitate to get in touch. Please leave a message at the [Issues page](https://github.com/Qoala-T/QC/issues).


## Citation

**When using Qoala-T please include the following citation:**

Klapwijk, E.T., van de Kamp, F., Meulen, M., Peters, S. and Wierenga, L.M. (2019). Qoala-T: A supervised-learning tool for quality control of FreeSurfer segmented MRI data. *NeuroImage, 189*, 116-129. https://doi.org/10.1016/j.neuroimage.2019.01.014


## Authors

Eduard T. Klapwijk, Ferdi van de Kamp, Mara van der Meulen, Sabine Peters, and Lara M. Wierenga

