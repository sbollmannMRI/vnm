#!/bin/bash

# fetch_and_run.sh [name] [version] [date] {cmd} {args}
# Example:
#   fetch_and_run.sh itksnap 3.8.0 20200505 itksnap-wt

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
    # curl -s -S -X GET https://swift.rc.nectar.org.au:8888/v1/AUTH_d6165cc7b52841659ce8644df1884d5e/singularityImages | grep -i ${IMG_NAME}
    # if [ $? -ne 0 ]; then
    #     echo "No image available for '${IMG_NAME}'."
    #     exit 1
    # fi
    # If available -> Install it
    CWD=$PWD
    cd ${VNM_PATH}
    git clone https://github.com/Neurodesk/transparent-singularity.git ${IMG_NAME}
    cd ${IMG_NAME}
    ./run_transparent_singularity.sh --container ${IMG_NAME}.sif
    rm -rf .git* README.md run_transparent_singularity ts_*
fi
echo "Module '${MOD_NAME}/${MOD_VERS}' is installed. Use the command 'module load ${MOD_NAME}/${MOD_VERS}' outside of this shell to use it."

# If no additional command -> Give user a shell in the image
if [ $# -le 3 ]; then
    source ~/.bashrc
    clear
    echo "you are now inside the container ${MOD_NAME}_${MOD_VERS}_${MOD_DATE}"
    singularity shell /vnm/${MOD_NAME}_${MOD_VERS}_${MOD_DATE}/${MOD_NAME}_${MOD_VERS}_${MOD_DATE}.sif \
    || echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" \
    && echo "the container you have has a bug and needs to be updated on your system. To trigger a reinstall, run:" \
    && echo "rm -rf /vnm/${MOD_NAME}_${MOD_VERS}_*" \
    && echo "rm -rf /vnm/modules/${MOD_NAME}/${MOD_VERS}" \
    && read -e -p "Would you like me to do this for you (Y for yes)? " choice \
    && [[ "$choice" == [Yy]* ]] && rm -rf /vnm/${MOD_NAME}_${MOD_VERS}_* && rm -rf /vnm/modules/${MOD_NAME}/${MOD_VERS}
fi

# If additional command -> Run it
module load ${MOD_NAME}/${MOD_VERS}
echo "Running command '${@:4}'."
${@:4}
