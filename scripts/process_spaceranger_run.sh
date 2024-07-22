#!/bin/bash
#SBATCH -N 1 -n 1 -c 20
#SBATCH --mem 128000
#SBATCH -t 12:00:00
#SBATCH -e job-%J.err
#SBATCH -o job-%J.out

module load spaceranger/3.0.0

echo "Running sample:" $1
echo "Slide ID:" $5
echo "Slide area:" $6

SAMPLE=$1
FASTQ=$2
HIRES=$3
CYT=$4
SLIDE=$5
AREA=$6
ALIGN=$7
ALIGN_FILE=$8
TYPE=$9
BIN=$10

if [ "$TYPE" == "standard" ]; then

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

# # Run spaceranger mouse:
#    spaceranger count --id=$SAMPLE \
#       --fastqs=$FASTQ \
#       --transcriptome=/fastdisk/10x/refdata-gex-mm10-2020-A/ \
#       --probe-set=/fastdisk/10x/CytAssist/Visium_Mouse_Transcriptome_Probe_Set_v1.0_mm10-2020-A.csv \
#       --sample=$SAMPLE \
#       --image=$HIRES \
#       --cytaimage=$CYT \
#       --slide=$SLIDE \
#       --area=$AREA

# # Run spaceranger mouse (manual align):
#    spaceranger count --id=$SAMPLE \
#       --fastqs=$FASTQ \
#       --transcriptome=/fastdisk/10x/refdata-gex-mm10-2020-A/ \
#       --probe-set=/fastdisk/10x/CytAssist/Visium_Mouse_Transcriptome_Probe_Set_v1.0_mm10-2020-A.csv \
#       --sample=$SAMPLE \
#       --image=$HIRES \
#       --cytaimage=$CYT \
#       --slide=$SLIDE \
#       --area=$AREA \
#       --loupe-alignment=$ALIGN