# HARDCODED TO AWS
# A dynamicStorage parameter type would be very helpful for this

# Copy path/to/simulation_<i> to bucket
merged_results=$(ls Results/merged.*)
aws s3 cp ${merged_results} s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number}/${merged_results}
aws s3 cp --recursive reports s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number}/reports
aws s3 cp --recursive TempData s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number}/TempData
