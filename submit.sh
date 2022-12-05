#!/bin/bash           # the shell language when run outside of the job scheduler
#                     # lines starting with #$ is an instruction to the job scheduler
#$ -S /bin/bash       # the shell language when run via the job scheduler [IMPORTANT]
#$ -cwd               # job should run in the current working directory
#$ -j y               # STDERR and STDOUT should be joined
#$ -l mem_free=32G     # job requires up to 1 GiB of RAM per slot
#$ -l scratch=16G      # job requires up to 2 GiB of local /scratch space
#$ -l h_rt=2:00:00   # job requires up to 24 hours of runtime
#$ -t 1-1739           # array job with 10 tasks (remove first '#' to enable)
#$ -r y               # if job crashes, it should be restarted

## If you array jobs (option -t), this script will run T times, once per task.
## For each run, $SGE_TASK_ID is set to the corresponding task index (here 1-10).
## To configure different parameters for each task index, one can use a Bash 
## array to map from the task index to a parameter string.

## All possible parameters
# params=(1bac 2xyz 3ijk 4abc 5def 6ghi 7jkl 8mno 9pqr 10stu)

## Select the parameter for the current task index
## Arrays are indexed from 0, so we subtract one from the task index
param="$((SGE_TASK_ID - 1))"

~/.conda/envs/cds_ensemble/bin/cds-ensemble fit-model \
    --x data/processed/features.ftr \
    --y data/processed/prepared_targets.ftr \
    --model-config src/ensemble_prediction_pipeline/config/ensemble-config.yaml \
    --model Methylation \
    --n-folds 5 \
    --target-range $((param*10)) $((((param+1))*10)) \
    --output-dir output/Methylation


date
hostname

## End-of-job summary, if running as a job
[[ -n "$JOB_ID" ]] && qstat -j "$JOB_ID"  # This is useful for debugging and usage purposes,
                                          # e.g. "did my job exceed its memory request?"