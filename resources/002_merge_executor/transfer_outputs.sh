# HARDCODED TO AWS
# A dynamicStorage parameter type would be very helpful for this

aws s3 cp --recursive merge.sh s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number}/merge.sh
aws s3 cp --recursive Results s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number}/Results
aws s3 cp --recursive TempData s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number}/TempData
