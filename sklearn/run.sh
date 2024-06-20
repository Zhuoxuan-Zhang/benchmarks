#!/bin/bash

set -e

PYTHON=${PYTHON:-`which python3`}
OUT=${OUT:-$PWD/result}
TMP=${TMP:-$PWD/tmp}
SCRIPTS=${SCRIPTS:-$PWD/scripts}

# Ideally, we'll move on to piping rather than writing to a file
MODEL=$TMP/model.obj
X=$TMP/X_train.obj
y=$TMP/y_train.obj
CLASSES=$TMP/classes.obj
DUAL=false # should be converted to bool inside script
MAX_SQ_SUM=$TMP/max_squared_sum.obj
WARM_COEF=$TMP/warm_start_coef.obj
C_=$TMP/C_.obj

# TODO: Try this out on a larger dataset
# TODO: Benchmark each phase

# Generating model & samples
$PYTHON $SCRIPTS/gen_model.py 100
$PYTHON $SCRIPTS/gen_samples.py

# Validity checking functions
# These functions just check to make sure that the input is valid. 
# If not they will raise an error. Otherwise, they do not mutate the data.
$PYTHON $SCRIPTS/check_solver.py $MODEL
penalty=$($PYTHON $SCRIPTS/penalty.py $MODEL)
$PYTHON $SCRIPTS/val_data.py $MODEL $X $y 
$PYTHON $SCRIPTS/classes.py $MODEL $y # This should return a classes with just the unique classes in y
multiclass=$($PYTHON $SCRIPTS/check_multiclass.py $MODEL)

# TODO: Benchmark each step of the pipeline
# Make a modified pipeline where each step writes its output to a file

# Calculations functions
$PYTHON $SCRIPTS/rownorm.py $X
n_classes=$($PYTHON $SCRIPTS/reshape_classes.py $MODEL $CLASSES)
$PYTHON $SCRIPTS/warm_start.py $MODEL $multiclass $n_classes # pipes coefficients

# KDD Cup 99 dataset has 23 classes
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 1
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 2
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 3
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 4
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 5
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 6
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 7
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 8
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 9
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 10
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 11
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 12
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 13
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 14
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 15
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 16
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 17
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 18
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 19
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 20
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 21
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 22
$PYTHON $SCRIPTS/parallel.py $MODEL $X $y $C_ $WARM_COEF $MAX_SQ_SUM $multiclass $penalty 23

$PYTHON $SCRIPTS/zip_coef.py $MODEL $n_classes
$PYTHON $SCRIPTS/adjust_coef.py $MODEL $X $multiclass $n_classes $OUT/trained_model.obj
