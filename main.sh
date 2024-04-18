#!/bin/bash
source inputs.sh

if [[ "${dcs_output_directory}" == "${dcs_model_directory}" || "${dcs_output_directory}" == "${dcs_model_directory}/"* ]]; then
    echo "Error: Output directory is a subdirectory of model directory." >&2
    exit 1
fi

# Use the resource wrapper
source /etc/profile.d/parallelworks.sh
source /etc/profile.d/parallelworks-env.sh
source /pw/.miniconda3/etc/profile.d/conda.sh

if [ -z "${workflow_utils_branch}" ]; then
    # If empty, clone the main default branch
    git clone https://github.com/parallelworks/workflow-utils.git
else
    # If not empty, clone the specified branch
    git clone -b "$workflow_utils_branch" https://github.com/parallelworks/workflow-utils.git
fi

conda activate
python3 ./workflow-utils/input_form_resource_wrapper.py 

if [ $? -ne 0 ]; then
    echo "Error: Input form resource wrapper failed. Exiting."
    exit 1
fi

# Load useful functions
source ./workflow-utils/workflow-libs.sh

# Copy useful functions
cp \
    ./workflow-utils/load_bucket_credentials_ssh.sh \
    ./workflow-utils/cpu_and_memory_usage.py \
    ./workflow-utils/cpu_and_memory_usage_requirements.yaml \
    resources/001_simulation_executor/

cp ./workflow-utils/load_bucket_credentials_ssh.sh resources/002_merge_executor/

# Run job on remote resource
cluster_rsync_exec

# Runs every cancel.sh script located on the remote resource directory
cancel_jobs_by_script