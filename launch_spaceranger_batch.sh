#!/usr/bin/bash

# # Initialize variables
ALIGN=""
FASTQ=""
img_path=""
output_path=""
BIN=48

# Usage function to display help
usage() {
    echo ""
    echo "Usage: $0 -t <type> -a <alignment> -f <fastq_path> -i <img_path> -o <output_path>"
    echo ""
    echo "-t <type>: Type of sample (standard or hd)"
    echo ""
    echo "-a <alignment>: auto (Automatic alignment) or manual (Manual alignment)"
    echo ""
    echo "-f <FASTQ>: Path to fastq files"
    echo ""
    echo "-i <img_path>: Path to image files"
    echo ""
    echo "-o <output_path>: Path to output files"
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
while getopts ":a:f:i:o:t:" opt; do
    case ${opt} in
    a)
        ALIGN=$OPTARG
        ;;
    f)
        FASTQ=$OPTARG
        ;;
    i)
        img_path=$OPTARG
        ;;
    o)
        output_path=$OPTARG
        ;;
    b)
        BIN=$OPTARG
        ;;
    t)
        TYPE=$OPTARG
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

# Check if alignment option is valid
if [ "$ALIGN" != "manual" ] && [ "$ALIGN" != "auto" ]; then
    echo "Error: Invalid alignment option provided: $ALIGN"
    usage
fi

# Check if type option is valid
if [ "$TYPE" != "standard" ] && [ "$TYPE" != "hd" ]; then
    echo "Error: Invalid type option provided: $TYPE"
    usage
fi

echo "Running the following settings:"
echo "Type: $TYPE"
echo "Alignment: $ALIGN"
echo "FASTQ: $FASTQ"
echo "Image path: $img_path"
echo "Output path: $output_path"

# Check if required variables are set
if [ -z "$FASTQ" ] || [ -z "$img_path" ] || [ -z "$output_path" ] || [-z "$TYPE" ]; then
    echo "Error: Missing required arguments."
    usage
fi

sample=$(find "$FASTQ"/V* "$FASTQ"/H* -printf '%f\n' 2>/dev/null | sed 's/_S.*//' | uniq)

if [ -z "$sample" ]; then
    echo "Error: No matching files found in $FASTQ."
    exit 1
fi

for ID in $(echo "$sample"); do
    SLIDE=$(echo "$ID" | sed 's/_.*//')
    AREA=$(echo "$ID" | sed 's/^.*[^_]*_//')
    HIRES=${img_path}/${ID}_HE.*
    CYT=${img_path}/${ID}_Cyt.tif
    ALIGN_FILE=${img_path}/${ID}_alignment.json

    echo "Running sample:" $ID
    echo "Slide ID:" $SLIDE
    echo "Slide area:" $AREA

    cd $output_path
    mkdir $ID
    cd $ID

    sbatch run_spaceranger_ffpe_V2.sh $ID $FASTQ $HIRES $CYT $SLIDE $AREA $ALIGN $ALIGN_FILE $TYPE $BIN
done
