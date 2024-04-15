# HARDCODED TO AWS
# A dynamicStorage parameter type would be very helpful for this

# Load credentials
eval $(ssh usercontainer ${pw_job_dir}/utils/bucket_token_generator.py --bucket_id ${dcs_bucket_id} --token_format text)

# Copy path/to/simulation_<i> to bucket
merged_results=$(ls Results/merged.*)
aws s3 cp ${merged_results} s3://$BUCKET_NAME/${s3_output_directory}/${USER}/${workflow_name}/${job_number}/${merged_results}
aws s3 cp --recursive reports s3://$BUCKET_NAME/${s3_output_directory}/${USER}/${workflow_name}/${job_number}/reports
aws s3 cp --recursive TempData s3://$BUCKET_NAME/${s3_output_directory}/${USER}/${workflow_name}/${job_number}/TempData
