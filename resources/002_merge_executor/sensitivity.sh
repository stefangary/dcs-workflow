
# generate the 3DCS macro script for the run
echo "Writing Macro File..."
echo

in_name=$(basename ${dcs_model_file%.*})

# Move results to common directory
mkdir -p Results
for f in $(find . -name *.hlm | grep Results);do
    mv ${f} Results/
done

num_runs=$(find . -name *.hlm | grep Results | wc -l)

cat > macroScript.txt <<END
//Generic Needed
DCSVERS	200
DCSMSSG	1  0 // 1st 0 MEANS print-msg is OFF; 2nd 0 MEANS using RELATIVE path
DCSWORK .
DCSCOMPLIANT  0 //load compliant or not: 0 -- not load; otherwise -- load
DCSMECHANICAL  0 //load Mechanical AddIn or not: 0 -- not load; otherwise -- load

//load a model (wtx) 
DCSLOAD $in_name.wtx

DCSSENS_MERGE $num_runs merged.hlm
END

# write the merge indices
for f in $(find . -name *.hlm | grep Results); do
    echo "DCS_DATA $(basename $f)" >> macroScript.txt
done

echo >> macroScript.txt
echo "DCSSIMU_LOAD merged" >> macroScript.txt
echo "DCSREPORT_GEN 1 ./reports" >> macroScript.txt
