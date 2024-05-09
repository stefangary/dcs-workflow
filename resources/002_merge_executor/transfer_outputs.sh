# HARDCODED TO AWS
# A dynamicStorage parameter type would be very helpful for this

# Copy path/to/simulation_<i> to bucket
# Delete unmerged results
rm -f Results/${in_name}_*.hst Results/${in_name}_*.hlm

aws s3 cp --recursive Results s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number}/Results
aws s3 cp --recursive TempData s3://$BUCKET_NAME/${dcs_output_directory}/${USER}/${workflow_name}/${job_number}/TempData
