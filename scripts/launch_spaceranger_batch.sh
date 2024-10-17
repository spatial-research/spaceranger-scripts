#!/usr/bin/bash

export LAUNCH_SCRIPT="launch_spaceranger_sbatch.sh"

# # Initialize variables
TYPE=standard
SPECIES=human
ALIGN=auto
FASTQ=""
img_path=""
he_path=""
cyt_path=""
output_path=""
BIN=48

# Usage function to display help
usage() {
    echo ""
    echo "Usage: $0 -t <type> -s <species> -a <alignment> -f <fastq_path> -i <img_path> -h <he_img_path> -c <cyt_img_oath> -o <output_path> -b <custom_bin_size>"
    echo ""
    echo "-t <type>: Type of sample (standard or hd). Default: standard"
    echo ""
    echo "-s <species>: Species type of sample (human or mouse). Default: human"
    echo ""
    echo "-a <alignment>: auto (Automatic alignment) or manual (Manual alignment). Default: auto"
    echo "If manual alignment is selected, please provide the alignment file as *_alignment.json in the image path (with both images) or CytAssist image path"
    echo ""
    echo "-f <FASTQ>: Path to fastq files"
    echo ""
    echo "-i <img_path>: Path to image files if both H&E and CytAssist are in the same location"
    echo ""
    echo "-h <he_img_path>: Path to H&E image files"
    echo ""
    echo "-c <cyt_img_path>: Path to CytAssist image files"
    echo ""
    echo "-o <output_path>: Path to output files"
    echo ""
    echo "-b <custom_bin_size>: Custom bin size for hd type. Default: 48"
    echo ""
    exit 1
}

# Check for -h option before anything else
for arg in "$@"; do
    if [ "$arg" = "-h" ]; then
        usage
        exit 0
    fi
done

# Parse options
while getopts ":t:s:a:f:i:h:c:o:b:" opt; do
    case ${opt} in
    t)
        TYPE=$OPTARG
        ;;
    s)
        SPECIES=$OPTARG
        ;;
    a)
        ALIGN=$OPTARG
        ;;
    f)
        FASTQ=$OPTARG
        ;;
    i)
        img_path=$OPTARG
        ;;
    h)
        he_path=$OPTARG
        ;;
    c)
        cyt_path=$OPTARG
        ;;
    o)
        output_path=$OPTARG
        ;;
    b)
        BIN=$OPTARG
        ;;
    \?)
        echo "Invalid Option: -$OPTARG" 1>&2
        usage
        ;;
    :)
        echo "Invalid option: $OPTARG requires an argument" 1>&2
        usage
        ;;
    esac
done

# Check if type option is valid
if [ "$TYPE" != "standard" ] && [ "$TYPE" != "hd" ]; then
    echo "Error: Invalid type option provided: $TYPE"
    usage
fi

# Check if species option is valid
if [ "$SPECIES" != "human" ] && [ "$SPECIES" != "mouse" ]; then
    echo "Error: Invalid species option provided: $TYPE"
    usage
fi

# Check if alignment option is valid
if [ "$ALIGN" != "manual" ] && [ "$ALIGN" != "auto" ]; then
    echo "Error: Invalid alignment option provided: $ALIGN"
    usage
fi

# Check if fastq variables are set
if [ -z "$FASTQ" ]; then
    echo "Error: Missing required arguments fastq."
    usage
fi

# Check if img is empty and either he_path or cyt_path is empty
if [ -z "$img_path" ] && ([ -z "$he_path" ] || [ -z "$cyt_path" ]); then
    echo "Error: Missing img_path arguments"
    echo "Please provide either img_path or both he_path and cyt_path"
    usage
fi

# Check if output_path is set
if [ -z "$output_path" ]; then
    echo "Error: Missing required arguments output_path."
    usage
fi

# Check if $BIN is an integer and greater than 8
if ! [[ "$BIN" =~ ^[0-9]+$ ]] || [ "$BIN" -le 8 ]; then
    echo "Error: BIN must be an integer greater than 8."
    usage
fi

sample=$(find "$FASTQ"/V* "$FASTQ"/H* -printf '%f\n' 2>/dev/null | sed 's/_S.*//' | uniq)

if [ -z "$sample" ]; then
    echo "Error: No matching files found in $FASTQ."
    exit 1
fi

if [ -n "$img_path" ]; then

    echo "Running the following settings:"
    echo "Type: $TYPE"
    echo "Alignment: $ALIGN"
    echo "FASTQ: $FASTQ"
    echo "Image path: $img_path"
    echo "Output path: $output_path"

    for ID in $(echo "$sample"); do
        SLIDE=$(echo "$ID" | sed 's/_.*//')
        AREA=$(echo "$ID" | sed 's/^.*[^_]*_//')
        HIRES=${img_path}/${ID}_HE.*
        CYT=${img_path}/${ID}_Cyt.tif
        ALIGN_FILE=${img_path}/${ID}_alignment.json

        echo "Running sample:" $ID
        echo "Slide ID:" $SLIDE
        echo "Slide area:" $AREA
        echo "Custom bin size (only used for HD):" $BIN

        cd $output_path
        mkdir $ID
        cd $ID

        sbatch process_spaceranger.sh $ID $TYPE $SPECIES $ALIGN $FASTQ $HIRES $CYT $SLIDE $AREA $ALIGN_FILE $BIN
    done

elif [ -n "$he_path" ] && [ -n "$cyt_path" ]; then

    echo "Running the following settings:"
    echo "Type: $TYPE"
    echo "Alignment: $ALIGN"
    echo "FASTQ: $FASTQ"
    echo "H&E path: $he_path"
    echo "CytAssist path: $cyt_path"
    echo "Output path: $output_path"

    for ID in $(echo "$sample"); do
        SLIDE=$(echo "$ID" | sed 's/_.*//')
        AREA=$(echo "$ID" | sed 's/^.*[^_]*_//')
        HIRES=${he_path}/${ID}*
        CYT=${cyt_path}/${ID}*.tif
        ALIGN_FILE=${cyt_path}/${ID}_alignment.json

        echo "Running sample:" $ID
        echo "Slide ID:" $SLIDE
        echo "Slide area:" $AREA
        echo "Custom bin size (only used for HD):" $BIN

        cd $output_path
        mkdir $ID
        cd $ID

        sbatch process_spaceranger.sh $ID $TYPE $SPECIES $ALIGN $FASTQ $HIRES $CYT $SLIDE $AREA $ALIGN_FILE $BIN
    done
fi
