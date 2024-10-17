#!/bin/bash
#SBATCH -N 1 -n 1 -c 14
#SBATCH --mem 128000
#SBATCH -t 12:00:00
#SBATCH -e job-%J.err
#SBATCH -o job-%J.out

# Check if script is started using launch_spaceranger_sbatch.sh
if [ -z "$LAUNCH_SCRIPT" ]; then
    echo "Error: Script not started using launch_spaceranger_sbatch.sh"
    echo "Please use launch_spaceranger_sbatch.sh"
    exit 1
fi

module load spaceranger

# Set variables from launch_spaceranger_batch.sh
SAMPLE=$1
TYPE=$2
SPECIES=$3
ALIGN=$4
FASTQ=$5
HIRES=$6
CYT=$7
SLIDE=$8
AREA=$9
ALIGN_FILE=${10}
BIN=${11}

echo "Running sample:" $1
echo "Slide ID:" $8
echo "Slide area:" $9

# Set reference data and probe path
if [ "$SPECIES" == "human" ]; then
    REF=/srv/home/10x.references/refdata-gex-GRCh38-2020-A/
    PROBE=/srv/home/10x.references/CytAssist/Visium_Human_Transcriptome_Probe_Set_v2.0_GRCh38-2020-A.csv
elif [ "$SPECIES" == "mouse" ]; then
    REF=/srv/home/10x.references/refdata-gex-mm10-2020-A/
    PROBE=/srv/home/10x.references/CytAssist/Visium_Mouse_Transcriptome_Probe_Set_v1.0_mm10-2020-A.csv

if [ "$TYPE" == "standard" ]; then

   if [ "$ALIGN" == "manual" ]; then
      echo "Running spaceranger human (manual align)"
      spaceranger count --id=$SAMPLE \
         --fastqs=$FASTQ \
         --transcriptome=$REF \
         --probe-set=$PROBE \
         --sample=$SAMPLE \
         --image=$HIRES \
         --cytaimage=$CYT \
         --slide=$SLIDE \
         --area=$AREA \
         --create-bam=false \
         --loupe-alignment=$ALIGN_FILE

   elif [ "$ALIGN" == "auto" ]; then
      echo "Running spaceranger human"
      spaceranger count --id=$SAMPLE \
         --fastqs=$FASTQ \
         --transcriptome=$REF \
         --probe-set=$PROBE \
         --sample=$SAMPLE \
         --image=$HIRES \
         --cytaimage=$CYT \
         --slide=$SLIDE \
         --area=$AREA \
         --create-bam=false
   fi

elif [ "$TYPE" == "hd" ]; then

   if [ "$ALIGN" == "manual" ]; then
      echo "Running spaceranger human (manual align)"
      spaceranger count --id=$SAMPLE \
         --fastqs=$FASTQ \
         --transcriptome=/fastdisk/10x/refdata-gex-GRCh38-2020-A/ \
         --probe-set=/fastdisk/10x/CytAssist/Visium_Human_Transcriptome_Probe_Set_v2.0_GRCh38-2020-A.csv \
         --sample=$SAMPLE \
         --image=$HIRES \
         --cytaimage=$CYT \
         --slide=$SLIDE \
         --area=$AREA \
         --create-bam=false \
         --custom-bin-size=$BIN \
         --loupe-alignment=$ALIGN_FILE

   elif [ "$ALIGN" == "auto" ]; then
      echo "Running spaceranger human"
      spaceranger count --id=$SAMPLE \
         --fastqs=$FASTQ \
         --transcriptome=/fastdisk/10x/refdata-gex-GRCh38-2020-A/ \
         --probe-set=/fastdisk/10x/CytAssist/Visium_Human_Transcriptome_Probe_Set_v2.0_GRCh38-2020-A.csv \
         --sample=$SAMPLE \
         --image=$HIRES \
         --cytaimage=$CYT \
         --slide=$SLIDE \
         --area=$AREA \
         --create-bam=false \
         --custom-bin-size=$BIN
   fi

fi

# End of script