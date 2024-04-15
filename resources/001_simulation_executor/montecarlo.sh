# CREATE MONTECARLO MACRO SCRIPT

out_hst=$(basename ${dcs_model_file%.*})_${case_index}


cat >> macroScript.txt <<END
DCSVERS	200
DCSMSSG	1  0
DCSWORK .

DCS_DEL_FILE *.hst

DCSLOAD ${dcs_model_file}

DCS_CFG_SETTING ${dcs_thread} 0

DCSSIMU_RUN_WITH_SEED 1 ${dcs_num_seeds} ${case_index} ${dcs_concurrency}
DCS_DATA ${out_hst}
END
