# CREATE MONTECARLO MACRO SCRIPT

if [[ ${dcs_compliant} == "true" ]]; then
    dcs_compliant=1
else
    dcs_compliant=0
fi

if [[ ${dcs_mechanical} == "true" ]]; then
    dcs_mechanical=1
else
    dcs_mechanical=0
fi

out_hst=$(basename ${dcs_model_file%.*})_${case_index}


cat >> macroScript.txt <<END
DCSVERS	200
DCSMSSG	1  0
DCSWORK .
DCSCOMPLIANT  ${dcs_compliant}
DCSMECHANICAL  ${dcs_mechanical}

DCS_DEL_FILE *.hst

DCSLOAD ${dcs_model_file}

DCS_CFG_SETTING ${dcs_thread} 0

DCSSIMU_RUN_WITH_SEED 1 ${dcs_num_seeds} ${case_index} ${dcs_concurrency}
DCS_DATA ${out_hst}
END
