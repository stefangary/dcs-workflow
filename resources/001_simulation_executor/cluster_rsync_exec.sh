#!/bin/bash
cd $(dirname $0)

source inputs.sh
source workflow-libs.sh

create_case(){
    # The merge tasks syncs the results from an S3 bucket. To simplify the path to the
    # results in the S3 bucket ww use the resource job dir
    case_dir=${resource_jobdir}/simulation_${case_index}
    mkdir -p ${case_dir}

    echo "    Writing job script"
    cp batch_header.sh  ${case_dir}/run_case.sh

    if [[ ${jobschedulertype} == "SLURM" ]]; then 
        echo "#SBATCH -o ${case_dir}/logs_${case_index}.out" >> ${case_dir}/run_case.sh
        echo "#SBATCH -e ${case_dir}/logs_${case_index}.out" >> ${case_dir}/run_case.sh
    elif [[ ${jobschedulertype} == "PBS" ]]; then
        echo "#PBS -o ${case_dir}/logs_${case_index}.out" >> ${case_dir}/run_case.sh
        echo "#PBS -e ${case_dir}/logs_${case_index}.out" >> ${case_dir}/run_case.sh
    fi
    
    # Main script
    echo "mkdir -p ${case_dir}" >> ${case_dir}/run_case.sh
    echo "cd ${case_dir}" >> ${case_dir}/run_case.sh
    
    # FIXME: This is needed because run directory is not shared between controller and compute nodes
    #echo "rsync -avzq ${resource_privateIp}:${case_dir}/ ."  >> ${case_dir}/run_case.sh

    # Main script
    echo >> ${case_dir}/run_case.sh
    cat inputs.sh >> ${case_dir}/run_case.sh
    echo "export case_index=${case_index}" >> ${case_dir}/run_case.sh
    echo >> ${case_dir}/run_case.sh

    cat transfer_inputs.sh >> ${case_dir}/run_case.sh
    cat ${dcs_analysis_type}.sh >> ${case_dir}/run_case.sh
    cat run_dcs.sh >> ${case_dir}/run_case.sh
    cat transfer_outputs.sh >> ${case_dir}/run_case.sh

}

echo; echo; echo "CREATING JOB SCRIPTS"
for case_index in $(seq 1 ${dcs_concurrency}); do
    echo; echo "  Case ${case_index}"
    create_case
done

echo; echo; echo "SUBMITTING JOB SCRIPTS"
for case_index in $(seq 1 ${dcs_concurrency}); do
    case_dir=${resource_jobdir}/simulation_${case_index}
    echo; echo "  Case ${case_index}"

    submit_job_sh=${case_dir}/run_case.sh
    echo "  Job script ${submit_job_sh}"

    if [[ ${jobschedulertype} == "SLURM" ]]; then 
        job_id=$(${submit_cmd} ${submit_job_sh} | tail -1 | awk -F ' ' '{print $4}')
    elif [[ ${jobschedulertype} == "PBS" ]]; then
        job_id=$(${submit_cmd} ${submit_job_sh} | tail -1)
    fi
    
    if [ -z "${job_id}" ]; then
        echo "  ERROR: ${submit_cmd} ${submit_job_sh} failed"
        exit 1
    else
        echo "  Submitted job ${job_id}"
        echo ${job_id} > ${case_dir}/job_id.submitted
    fi
done



echo; echo "CHECKING JOBS STATUS"
while true; do
    date
    submitted_jobs=$(find ${resource_jobdir} -name job_id.submitted)

    if [ -z "${submitted_jobs}" ]; then
        if [[ "${FAILED}" == "true" ]]; then
            echo "ERROR: Jobs [${FAILED_JOBS}] failed"
            exit 1
        fi
        echo "  All jobs are completed. Please check job logs in directories [${case_dirs}] and results"
        break
    fi

    FAILED=false

    for sj in ${submitted_jobs}; do
        jobid=$(cat ${sj})
      
        if [[ ${jobschedulertype} == "SLURM" ]]; then
            get_slurm_job_status
            # If job status is empty job is no longer running
            if [ -z "${job_status}" ]; then
                job_status=$($sshcmd sacct -j ${jobid}  --format=state | tail -n1)
                if [[ "${job_status}" == *"FAILED"* ]]; then
                    echo "ERROR: SLURM job [${jobid}] failed"
                    FAILED=true
                    FAILED_JOBS="${job_id}, ${FAILED_JOBS}"
                    mv ${sj} ${sj}.failed
                else
                    echo "Job ${jobid} was completed"
                    mv ${sj} ${sj}.completed
                    case_dir=$(dirname ${sj} | sed "s|${PWD}/||g")
                fi
            fi

        elif [[ ${jobschedulertype} == "PBS" ]]; then
            get_pbs_job_status
            if [[ "${job_status}" == "C" || -z "${job_status}" ]]; then
                echo "Job ${jobid} was completed"
                mv ${sj} ${sj}.completed
                case_dir=$(dirname ${sj} | sed "s|${PWD}/||g")
            fi
        fi

    done
    sleep 30
done

#echo; echo "TRANSFERRING RESULTS TO PW"
#rsync -avzq ${PWD}/ usercontainer:${PW_RESOURCE_DIR}/
