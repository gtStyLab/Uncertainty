# Uncertainty

## Overview 
Code repository for manuscript _Assessing structural uncertainty of biochemical regulatory networks in metabolic pathways across varying data qualities_  
Authors: Yue Han & Mark Styczynski 

## Folder Description
**calc_metric**: calculate error metrics between fitted and experimental data
**GenData**: functions required to generate synthetic data    
**kineticMaps**: putative regulatory network topologies for each stoichiometric network motif   
**miscellaneous**: support functions    
**paramsList**: all parameterizations of all stoichiometric network motifs and regulatory network topologies   
**test_saved_files**: compiled result files    

## Main File Description 
**wrapper_fitAllMaps.m**: parameter estimation and metrics calculation for all putative regulatory network models
**wrapper_network_fitting_v3_partial.m**: parameter estimation and metrics calculation for one putative regulatory network model   
**network_modelFitting_v2_partial.m**: parameter estimation for one putative regulatory network model 
**wrapper_model_evaluation.m**: Get metrics for a fitted regulatory network model     

**wrapper_construct_result_struct.m**: Compile a .mat result file from fitted results     
**wrapper_construct_result_struct_more_missing.m**: Compile a .mat result file from fitted results from more missing metabolites      
**count_number_unidentifiable_regNetwork_v2.m**: Export ranking of true regulatory network model using all metrics      
**count_number_unidentifiable_regNetwork_v3.m**: Export ranking of true regulatory network model using BIC         

**plot_figures**: Plot figures for manuscripts 

## Instructions for reproducing results in manuscript:    
- Run driver_genDatasets.m and generate BSTData folder under GenData
- Run wrapper_fitAllMaps.m for all stoichiometric network motifs, regulatory networks, parameterizations, noise levels, sampling rates, noise replicates, and missing metabolites. This will generate a folder named 'partial_fitting_results'
- Run wrapper_construct_result_struct.m to compile results from partial_fitting_results. The result structure will be saved under the folder test_saved_files
- Run plot_figures to reproduce manuscript figures
