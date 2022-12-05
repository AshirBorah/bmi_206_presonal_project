# bmi_206_presonal_project
A project to explore the effect of methylation on dependency analysis


Commands

cds-ensemble prepare-y --input data/raw/gene_effect.csv --output data/processed/prepared_targets.ftr

cds-ensemble prepare-x \
--targets data/processed/prepared_targets.ftr \
--model-config src/ensemble_prediction_pipeline/config/ensemble-config.yaml \
--feature-info src/ensemble_prediction_pipeline/config/Public-file-location.txt \
--output data/processed/features \
--confounders CRISPR-Confounders \
--output-format .ftr

cds-ensemble prepare-x \
--targets data/processed/prepared_targets.ftr \
--model-config src/ensemble_prediction_pipeline/config/ensemble-config_permutated.yaml \
--feature-info src/ensemble_prediction_pipeline/config/Public-file-location.txt \
--output data/processed/features_permutated \
--confounders CRISPR-Confounders \
--output-format .ftr


cds-ensemble fit-model \
--x data/processed/features.ftr \
--y data/processed/prepared_targets.ftr \
--model-config src/ensemble_prediction_pipeline/config/ensemble-config.yaml \
--model Methylation \
--n-folds 5 \
--target-range 0 2 \
--output-dir test 

cds-ensemble fit-model \
--x data/processed/features_permutated.ftr \
--y data/processed/prepared_targets.ftr \
--model-config src/ensemble_prediction_pipeline/config/ensemble-config_permutated.yaml \
--model Methylation \
--target-range 0 10 \
--output-dir output 


# Compile tasks
sparkle_params <- args[1]
feat_suffix <- args[2]
pred_suffix <- args[3]
tmp_file_dir <- args[4]
data_name <- args[5]
target <- args[6]

Rscript src/ensemble_prediction_pipeline/compile_ensemble_tasks.R data/processed/parameter_file.csv "features" "predictions" "temp" "DepMap" "CRISPR"

## Calculate accuracy
Rscript src/ensemble_prediction_pipeline/model_accuracy_regression.R DepMap-Methylation-features-CRISPR.csv DepMap-Methylation-predictions-CRISPR.csv data/processed/prepared_targets.ftr DepMap-Methylation-CRISPR.csv


Rscript src/ensemble_prediction_pipeline/model_accuracy_regression.R DepMap-Methylation_permutated-features-CRISPR.csv DepMap-Methylation_permutated-predictions-CRISPR.csv data/processed/prepared_targets.ftr DepMap-Methylation_permutated-CRISPR.csv

## Gather results
Rscript src/ensemble_prediction_pipeline/gather_ensemble.R DepMap-Methylation_prediction_summary.csv DepMap-Methylation-CRISPR.csv DepMap-Methylation_permutated-CRISPR.csv