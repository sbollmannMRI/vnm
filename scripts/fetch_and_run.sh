#!/bin/bash

# Read arguments
MOD_NAME=$1
MOD_VERS=$2
MOD_DATE=$3

# Initialize lmod
source /usr/share/module.sh
VNM_PATH=/vnm
MODS_PATH=${VNM_PATH}/modules
module use ${MODS_PATH}

# Check if the module is installed
module avail -t 2>&1 | grep -i ${MOD_NAME}/${MOD_VERS}
if [ $? -ne 0 ]; then
    # Check if module is available somewhere
    IMG_NAME=${MOD_NAME}_${MOD_VERS}_${MOD_DATE}
    curl -s -S -X GET https://swift.rc.nectar.org.au:8888/v1/AUTH_d6165cc7b52841659ce8644df1884d5e/singularityImages | grep -i ${IMG_NAME}
    if [ $? -ne 0 ]; then
        echo "No image available for '${IMG_NAME}'."
        exit 1
    fi
    # If available -> Install it
    CWD=$PWD
    cd ${VNM_PATH}
    git clone https://github.com/CAIsr/transparent-singularity.git ${IMG_NAME}
    cd ${IMG_NAME}
    ./run_transparent_singularity.sh --container ${IMG_NAME}.sif
    rm -rf .git* README.md run_transparent_singularity ts_*
fi

# If no additional command -> Exit
if [ $# -le 3 ]; then
    echo "Module '${MOD_NAME}/${MOD_VERS}' is installed."
    echo "Use 'module load ${MOD_NAME}/${MOD_VERS}' to activate it."
    exit 0
fi

# If additional command -> Run it
module load ${MOD_NAME}/${MOD_VERS}
${@:4}
