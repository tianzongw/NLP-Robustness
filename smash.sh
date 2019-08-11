#!/bin/bash
DATA_DIR="./data/raw_dataset"
BATCH_ID="AmazonSplit2"
num_train_epochs=4.0
learning_rate=4e-5

train(){

    task_name=${1}    

    RUN_TAG="${BATCH_ID}-train-${task_name}"
    TRAIN_TASK_NAME=${task_name}
    EVAL_TASK_NAME=${task_name}

    python ./src/run_glue.py \
        --model_type bert \
        --model_name_or_path bert-base-uncased \
        --task_name ${EVAL_TASK_NAME} \
        --do_train \
        --do_eval \
        --do_lower_case \
        --data_dir ${DATA_DIR}/${EVAL_TASK_NAME} \
        --max_seq_length 64 \
        --per_gpu_eval_batch_size=32   \
        --per_gpu_train_batch_size=32   \
        --learning_rate ${learning_rate} \
        --num_train_epochs ${num_train_epochs} \
        --save_steps 200 \
        --overwrite_output_dir \
        --output_dir ./model/${BATCH_ID}/${RUN_TAG} >> ./log.txt 2>&1

    echo ${RUN_TAG}
}

test(){
    train_name=${1}
    test_name=${2}
    model_run_tag=${3}

    RUN_TAG="${BATCH_ID}-[${model_run_tag}]-${test_name}"
    TRAIN_TASK_NAME=${train_name}
    EVAL_TASK_NAME=${test_name}

    if [ ${model_run_tag} == "bert-base-uncased" ]
    then
        model_path="bert-base-uncased"
    else
        model_path="./model/${BATCH_ID}/${model_run_tag}"
    fi

    python ./src/run_glue.py \
        --model_type bert \
        --model_name_or_path ${model_path} \
        --task_name ${EVAL_TASK_NAME} \
        --do_train \
        --do_eval \
        --do_lower_case \
        --data_dir ${DATA_DIR}/${EVAL_TASK_NAME} \
        --max_seq_length 64 \
        --per_gpu_eval_batch_size=32   \
        --per_gpu_train_batch_size=32   \
        --learning_rate 0 \
        --num_train_epochs 0.0 \
        --save_steps 200 \
        --overwrite_output_dir \
        --output_dir ./model/${BATCH_ID}/${RUN_TAG} >> ./log.txt 2>&1

    echo ${RUN_TAG}
}

# # untrained performance 
# test "STS-B-MSRPAR" "STS-B-MSRPAR" "bert-base-uncased"
# test "STS-B-HEADLINES" "STS-B-HEADLINES" "bert-base-uncased"
# test "STS-B-MSRVID" "STS-B-MSRVID" "bert-base-uncased"
# test "STS-B-IMAGES" "STS-B-IMAGES" "bert-base-uncased"

# # trained
# MSRPAR_MODEL=`train "STS-B-MSRPAR"`
# test "STS-B-MSRPAR" "STS-B-HEADLINES" ${MSRPAR_MODEL}
# HEADLINES_MODEL=`train "STS-B-HEADLINES"`
# test "STS-B-HEADLINES" "STS-B-MSRPAR" ${HEADLINES_MODEL}
# MSRVID_MODEL=`train "STS-B-MSRVID"`
# test "STS-B-MSRVID" "STS-B-IMAGES" ${MSRVID_MODEL}
# IMAGES_MODEL=`train "STS-B-IMAGES"`
# test "STS-B-IMAGES" "STS-B-MSRVID" ${IMAGES_MODEL}

# # MNLI-experiments
# test "MNLI-TELEPHONE" "MNLI-TELEPHONE" "bert-base-uncased" 
# test "MNLI-LETTERS" "MNLI-LETTERS" "bert-base-uncased" 
# test "MNLI-FACETOFACE" "MNLI-FACETOFACE" "bert-base-uncased" 

# TELEPHONE_MODEL=`train "MNLI-TELEPHONE"`
# test "MNLI-TELEPHONE" "MNLI-LETTERS" ${TELEPHONE_MODEL}
# test "MNLI-TELEPHONE" "MNLI-FACETOFACE" ${TELEPHONE_MODEL}

# ALL_MODEL=`train "MNLI"`
# test "MNLI" "MNLI-TELEPHONE" ${ALL_MODEL}
# test "MNLI" "MNLI-LETTERS" ${ALL_MODEL}
# test "MNLI" "MNLI-FACETOFACE" ${ALL_MODEL}

# Amazon

AMAZON_C_MODEL=`train "AMAZON-C-SAMPLE"`
test "AMAZON-C-SAMPLE" "AMAZON-WC-SAMPLE" ${AMAZON_C_MODEL}
test "AMAZON-C-SAMPLE" "AMAZON-MC-SAMPLE" ${AMAZON_C_MODEL}
test "AMAZON-C-SAMPLE" "AMAZON-BC-SAMPLE" ${AMAZON_C_MODEL}
test "AMAZON-C-SAMPLE" "AMAZON-S-SAMPLE" ${AMAZON_C_MODEL}
test "AMAZON-C-SAMPLE" "AMAZON-MS-SAMPLE" ${AMAZON_C_MODEL}
test "AMAZON-C-SAMPLE" "AMAZON-MV-SAMPLE" ${AMAZON_C_MODEL}
test "AMAZON-C-SAMPLE" "AMAZON-B-SAMPLE" ${AMAZON_C_MODEL}

AMAZON_WC_MODEL=`train "AMAZON-WC-SAMPLE"`
test "AMAZON-WC-SAMPLE" "AMAZON-C-SAMPLE" ${AMAZON_WC_MODEL}
test "AMAZON-WC-SAMPLE" "AMAZON-MC-SAMPLE" ${AMAZON_WC_MODEL}
test "AMAZON-WC-SAMPLE" "AMAZON-BC-SAMPLE" ${AMAZON_WC_MODEL}
test "AMAZON-WC-SAMPLE" "AMAZON-S-SAMPLE" ${AMAZON_WC_MODEL}
test "AMAZON-WC-SAMPLE" "AMAZON-MS-SAMPLE" ${AMAZON_WC_MODEL}
test "AMAZON-WC-SAMPLE" "AMAZON-MV-SAMPLE" ${AMAZON_WC_MODEL}
test "AMAZON-WC-SAMPLE" "AMAZON-B-SAMPLE" ${AMAZON_WC_MODEL}

AMAZON_MC_MODEL=`train "AMAZON-MC-SAMPLE"`
test "AMAZON-MC-SAMPLE" "AMAZON-C-SAMPLE" ${AMAZON_MC_MODEL}
test "AMAZON-MC-SAMPLE" "AMAZON-WC-SAMPLE" ${AMAZON_MC_MODEL}
test "AMAZON-MC-SAMPLE" "AMAZON-BC-SAMPLE" ${AMAZON_MC_MODEL}
test "AMAZON-MC-SAMPLE" "AMAZON-S-SAMPLE" ${AMAZON_MC_MODEL}
test "AMAZON-MC-SAMPLE" "AMAZON-MS-SAMPLE" ${AMAZON_MC_MODEL}
test "AMAZON-MC-SAMPLE" "AMAZON-MV-SAMPLE" ${AMAZON_MC_MODEL}
test "AMAZON-MC-SAMPLE" "AMAZON-B-SAMPLE" ${AMAZON_MC_MODEL}

AMAZON_BC_MODEL=`train "AMAZON-BC-SAMPLE"`
test "AMAZON-BC-SAMPLE" "AMAZON-C-SAMPLE" ${AMAZON_BC_MODEL}
test "AMAZON-BC-SAMPLE" "AMAZON-WC-SAMPLE" ${AMAZON_BC_MODEL}
test "AMAZON-BC-SAMPLE" "AMAZON-MC-SAMPLE" ${AMAZON_BC_MODEL}
test "AMAZON-BC-SAMPLE" "AMAZON-S-SAMPLE" ${AMAZON_BC_MODEL}
test "AMAZON-BC-SAMPLE" "AMAZON-MS-SAMPLE" ${AMAZON_BC_MODEL}
test "AMAZON-BC-SAMPLE" "AMAZON-MV-SAMPLE" ${AMAZON_BC_MODEL}
test "AMAZON-BC-SAMPLE" "AMAZON-B-SAMPLE" ${AMAZON_BC_MODEL}

AMAZON_S_MODEL=`train "AMAZON-S-SAMPLE"`
test "AMAZON-S-SAMPLE" "AMAZON-C-SAMPLE" ${AMAZON_S_MODEL}
test "AMAZON-S-SAMPLE" "AMAZON-WC-SAMPLE" ${AMAZON_S_MODEL}
test "AMAZON-S-SAMPLE" "AMAZON-MC-SAMPLE" ${AMAZON_S_MODEL}
test "AMAZON-S-SAMPLE" "AMAZON-BC-SAMPLE" ${AMAZON_S_MODEL}
test "AMAZON-S-SAMPLE" "AMAZON-MS-SAMPLE" ${AMAZON_S_MODEL}
test "AMAZON-S-SAMPLE" "AMAZON-MV-SAMPLE" ${AMAZON_S_MODEL}
test "AMAZON-S-SAMPLE" "AMAZON-B-SAMPLE" ${AMAZON_S_MODEL}

AMAZON_MS_MODEL=`train "AMAZON-MS-SAMPLE"`
test "AMAZON-MS-SAMPLE" "AMAZON-C-SAMPLE" ${AMAZON_MS_MODEL}
test "AMAZON-MS-SAMPLE" "AMAZON-WC-SAMPLE" ${AMAZON_MS_MODEL}
test "AMAZON-MS-SAMPLE" "AMAZON-MC-SAMPLE" ${AMAZON_MS_MODEL}
test "AMAZON-MS-SAMPLE" "AMAZON-BC-SAMPLE" ${AMAZON_MS_MODEL}
test "AMAZON-MS-SAMPLE" "AMAZON-S-SAMPLE" ${AMAZON_MS_MODEL}
test "AMAZON-MS-SAMPLE" "AMAZON-MV-SAMPLE" ${AMAZON_MS_MODEL}
test "AMAZON-MS-SAMPLE" "AMAZON-B-SAMPLE" ${AMAZON_MS_MODEL}

AMAZON_MV_MODEL=`train "AMAZON-MV-SAMPLE"`
test "AMAZON-MV-SAMPLE" "AMAZON-C-SAMPLE" ${AMAZON_MV_MODEL}
test "AMAZON-MV-SAMPLE" "AMAZON-WC-SAMPLE" ${AMAZON_MV_MODEL}
test "AMAZON-MV-SAMPLE" "AMAZON-MC-SAMPLE" ${AMAZON_MV_MODEL}
test "AMAZON-MV-SAMPLE" "AMAZON-BC-SAMPLE" ${AMAZON_MV_MODEL}
test "AMAZON-MV-SAMPLE" "AMAZON-S-SAMPLE" ${AMAZON_MV_MODEL}
test "AMAZON-MV-SAMPLE" "AMAZON-MS-SAMPLE" ${AMAZON_MV_MODEL}
test "AMAZON-MV-SAMPLE" "AMAZON-B-SAMPLE" ${AMAZON_MV_MODEL}

AMAZON_B_MODEL=`train "AMAZON-B-SAMPLE"`
test "AMAZON-B-SAMPLE" "AMAZON-C-SAMPLE" ${AMAZON_B_MODEL}
test "AMAZON-B-SAMPLE" "AMAZON-WC-SAMPLE" ${AMAZON_B_MODEL}
test "AMAZON-B-SAMPLE" "AMAZON-MC-SAMPLE" ${AMAZON_B_MODEL}
test "AMAZON-B-SAMPLE" "AMAZON-BC-SAMPLE" ${AMAZON_B_MODEL}
test "AMAZON-B-SAMPLE" "AMAZON-S-SAMPLE" ${AMAZON_B_MODEL}
test "AMAZON-B-SAMPLE" "AMAZON-MS-SAMPLE" ${AMAZON_B_MODEL}
test "AMAZON-B-SAMPLE" "AMAZON-MV-SAMPLE" ${AMAZON_B_MODEL}
# untrained
test "AMAZON-C-SAMPLE" "AMAZON-C-SAMPLE" "bert-base-uncased"
test "AMAZON-B-SAMPLE" "AMAZON-B-SAMPLE" "bert-base-uncased"
test "AMAZON-WC-SAMPLE" "AMAZON-WC-SAMPLE" "bert-base-uncased"
test "AMAZON-MC-SAMPLE" "AMAZON-MC-SAMPLE" "bert-base-uncased"
test "AMAZON-BC-SAMPLE" "AMAZON-BC-SAMPLE" "bert-base-uncased"
test "AMAZON-S-SAMPLE" "AMAZON-S-SAMPLE" "bert-base-uncased"
test "AMAZON-MS-SAMPLE" "AMAZON-MS-SAMPLE" "bert-base-uncased"
test "AMAZON-MV-SAMPLE" "AMAZON-MV-SAMPLE" "bert-base-uncased"
test "STS-B-MSRPAR" "STS-B-MSRPAR" "bert-base-uncased"
