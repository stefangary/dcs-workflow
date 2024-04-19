
# generate the 3DCS macro script for the run
echo "Writing Macro File..."
echo

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

in_name=$(basename ${dcs_model_file%.*})

# Move results to common directory
mkdir -p Results
for f in $(find . -name *.hst | grep Results);do
    mv ${f} Results/
done

num_runs=$(find . -name *.hst | grep Results | wc -l)

cat > macroScript.txt <<END
//Generic Needed
DCSVERS	200
DCSMSSG	1  0 // 1st 0 MEANS print-msg is OFF; 2nd 0 MEANS using RELATIVE path
DCSWORK .
DCSCOMPLIANT  ${dcs_compliant} //load compliant or not: 0 -- not load; otherwise -- load
DCSMECHANICAL  ${dcs_mechanical} //load Mechanical AddIn or not: 0 -- not load; otherwise -- load
DCSLOAD_CFG dcs4d.cfg

//load a model (wtx) 
DCSLOAD $in_name.wtx

//merge results files (in Results folder)
#DCS_MERGE_HST $num_runs merged.hst
DCSSIMU_MERGE $num_runs merged.hst
END

# write the merge indices
for f in $(find . -name *.hst | grep Results); do
    echo "DCS_DATA $(basename $f)" >> macroScript.txt
done

echo >> macroScript.txt
echo "DCSSIMU_LOAD merged" >> macroScript.txt
echo "DCSREPORT_GEN 1 ./reports" >> macroScript.txt
