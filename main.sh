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
conda activate
python3 ./utils/input_form_resource_wrapper.py 

if [ $? -ne 0 ]; then
    echo "Error: Input form resource wrapper failed. Exiting."
    exit 1
fi

# Load useful functions
source ./utils/workflow-libs.sh

# Run job on remote resource
cluster_rsync_exec