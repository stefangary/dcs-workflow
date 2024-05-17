# HARDCODED TO AWS
# A dynamicStorage parameter type would be very helpful for this

mkdir tmp-data-transfer
cd tmp-data-transfer

# dcs_model_directory can end with or without /
aws s3 sync s3://$BUCKET_NAME/${dcs_model_directory} .

# User aws s3 cp --recursive ../test s3://$BUCKET_NAME/path/to/dir/test to transfer to the bucket

# Find all files ending in ".wtx" in the current directory, excluding subdirectories
export dcs_model_file=$(find . -type f -name "*.wtx")

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


# Get the count of directories in the current directory
dir_count=$(ls -d */ | wc -l)

# If there's only one directory
if [ "$dir_count" -eq 1 ]; then
    # Get the name of the directory
    fea_dir=$(ls -d */ | head -n 1)
    export fea_dir=${fea_dir%/}  # Remove trailing slash
    echo "Directory found: $fea_dir"
else
    # If no directory or multiple directories exist
    echo "Error: Either no FEA directory found or multiple directories exist." >&2
    exit 1
fi

cd ..
mv tmp-data-transfer/* .
