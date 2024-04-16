# HARDCODED TO AWS
# A dynamicStorage parameter type would be very helpful for this

# Load credentials
eval $(ssh ${resource_ssh_usercontainer_options} usercontainer ${pw_job_dir}/utils/bucket_token_generator.py --bucket_id ${dcs_bucket_id} --token_format text)

# Transfer model

# dcs_model_directory can end with or without /

aws s3 sync s3://$BUCKET_NAME/${dcs_model_directory} .
aws s3 sync s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number} .

# Find all files ending in ".wtx" in the current directory, excluding subdirectories
dcs_model_file=$(find . -maxdepth 1 -type f -name "*.wtx")

# Check if dcs_model_file is empty
if [ -z "$dcs_model_file" ]; then
    echo "Error: No '.wtx' files found."
    exit 1
fi

# Count the number of files found
file_count=$(echo "$dcs_model_file" | wc -l)

# Check if only one file ending in ".wtx" is found
if [ "$file_count" -eq 1 ]; then
    echo "Found file ${dcs_model_file}"
else
    echo "Error: Found $file_count '.wtx' files. Expected only one."
    exit 1
fi
