#!/bin/bash

# use different samples to avoid disk cache
SAMPLE_PREFIX1="/tmp/sample1"
SAMPLE_PREFIX2="/tmp/sample2"
RESULT_PREFIX1="/tmp/result1"
RESULT_PREFIX2="/tmp/result2"

SIZES=(512 1024 2048)

# generate samples
echo "Generate samples..."
for sz in "${SIZES[@]}"
do
    dd if="/dev/zero" bs=1024k count=$sz | tr "\000" "A" > "${SAMPLE_PREFIX1}_$sz"
    dd if="/dev/zero" bs=1024k count=$sz | tr "\000" "A" > "${SAMPLE_PREFIX2}_$sz"
done

# profiler
echo "Do performance testing..."
for sz in "${SIZES[@]}"
do
    python -m cProfile -s cumulative floss/strings_buf_filled_with.py "${SAMPLE_PREFIX1}_$sz" > "${RESULT_PREFIX1}_$sz"
    python -m cProfile -s cumulative floss/strings_count.py "${SAMPLE_PREFIX2}_$sz" > "${RESULT_PREFIX2}_$sz"
done

