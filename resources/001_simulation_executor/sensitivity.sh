# CREATE SENSITIVITY MACRO SCRIPT

out_hst=$(basename ${dcs_model_file%.*})_${case_index}

cat >> macroScript.txt <<END
DCSVERS	200
DCSMSSG	1  0
DCSWORK .
DCSCOMPLIANT  ${dcs_compliant}
DCSMECHANICAL  ${dcs_mechanical}

DCS_DEL_FILE *.hlm

DCSLOAD ${dcs_model_file}

DCS_CFG_SETTING ${dcs_thread} 0

DCSSENS_CONTRIBUTOR ${dcs_concurrency} ${case_index} ${out_hst}

END
