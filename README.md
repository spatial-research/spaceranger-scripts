# Space Ranger SLURM Job Queueing Script

This repository contains a script to streamline the process of queuing Space Ranger jobs for multiple samples on a SLURM-based high-performance computing (HPC) cluster. Space Ranger (10x Genomics) used for processing Visium spatial gene expression data.

By default the --create-bam is set to false to save disk space.

## Setup

1. **Clone the Repository:**

```bash
git clone https://github.com/spatial-research/spaceranger-scripts
cd spaceranger-scripts
```

2. **Add script directory to PATH:**

You can manually add the scripts directory to your PATH by editing your shell profile (~/.bashrc, ~/.bash_profile, or ~/.zshrc), or use the init.sh script to do it automatically.

```bash
./init.sh
```

This will add the following block to your shell profile:

```bash
# >>> spaceranger-scripts >>>
# !! Contents within this block was added by 'init.sh' from spaceranger-scripts !!
export PATH="$PATH:/path/to/spaceranger-scripts/scripts"
# <<< spaceranger-scripts <<<
```

## Input naming requirement

### FF

```
project/ 
├── fastq/ 
│   ├── V13Y08-062_A1_S1_R1_001.fastq.gz
│   ├── V13Y08-062_A1_S1_R2_001.fastq.gz
│   ├── V13Y08-062_B1_S2_R1_001.fastq.gz
│   ├── V13Y08-062_B1_S2_R2_001.fastq.gz
│   ├── V13Y08-062_C1_S3_R1_001.fastq.gz
│   ├── V13Y08-062_C1_S3_R2_001.fastq.gz
│   ├── V13Y08-062_D1_S4_R1_001.fastq.gz
│   ├── V13Y08-062_D1_S4_R2_001.fastq.gz
│   └── ...
├── imgs/
│   ├── V13Y08-062_A1.tif (or .jpg)
│   ├── V13Y08-062_A1_alignment.json *(if manual align)*
│   ├── V13Y08-062_B1.tif (or .jpg)
│   ├── V13Y08-062_B1_alignment.json *(if manual align)*
│   ├── V13Y08-062_C1.tif (or .jpg)
│   ├── V13Y08-062_C1_alignment.json *(if manual align)*
│   ├── V13Y08-062_D1.tif (or .jpg)
│   ├── V13Y08-062_D1_alignment.json *(if manual align)*
│   └── ...
└── spaceranger_out/
```

### FFPE and HD

```
# One directory for both images

project/ 
├── fastq/ 
│   ├── V52L26-037_A_S1_R1_001.fastq.gz
│   ├── V52L26-037_A_S1_R2_001.fastq.gz
│   ├── V52L26-037_B_S2_R1_001.fastq.gz
│   ├── V52L26-037_B_S2_R2_001.fastq.gz
│   └── ...
├── imgs/
│   ├── V52L26-037_A_HE.tif
│   ├── V52L26-037_A_Cyt.tif
│   ├── V52L26-037_A_alignment.json *(if manual align)*
│   ├── V52L26-037_B_HE.tif
│   ├── V52L26-037_B_Cyt.tif
│   ├── V52L26-037_B_alignment.json *(if manual align)*
│   └── ...
└── spaceranger_out/

# Seperate directories for images

project/ 
├── fastq/ 
│   ├── V52L26-037_A_S1_R1_001.fastq.gz
│   ├── V52L26-037_A_S1_R2_001.fastq.gz
│   ├── V52L26-037_B_S2_R1_001.fastq.gz
│   ├── V52L26-037_B_S2_R2_001.fastq.gz
│   └── ...
├── he/
│   ├── V52L26-037_A.tif
│   ├── V52L26-037_B.tif
│   └── ...
├── cytassist/
│   ├── V52L26-037_A.tif
│   ├── V52L26-037_A_alignment.json *(if manual align)*
│   ├── V52L26-037_B.tif
│   ├── V52L26-037_B_alignment.json *(if manual align)*
│   └── ...
└── spaceranger_out/
```

## Usage

### Help

```
launch_spaceranger_batch.sh -h
```

### Example runs

IMPORTANT: Use -i option for image directory when running regular poly-A Visium V1

```
# FF with automatic alignment
launch_spaceranger_batch.sh -t ff -a auto -f ~/project/fastq -i ~/porject/imgs -o ~/project/spaceranger_out

# FFPE with manual alignment and common folder for images
launch_spaceranger_batch.sh -t ffpe -a manual -f ~/project/fastq -i ~/porject/imgs -o ~/project/spaceranger_out

# HD with seperate folders for images, manual alignment and custom bin size of 24
launch_spaceranger_batch.sh -t hd -a manual -f ～/project/fastq -h ~/project/he -c ~/project/cytassist -o ~/project/spaceranger_out -b 24
```

## Output example

```
spaceranger_out/ 
├── V52L26-037_A
|   |-- job-73311.err
|   |-- job-73311.out
|   └-- V52L26-037_A
|       |-- outs/
|       |-- SPATIAL_RNA_COUNTER_CS/
|       |-- V52L26-037_A.mri.tgz
|       └-- ...
├── V52L26-037_B
|   |-- job-73312.err
|   |-- job-73312.out
|   └-- V52L26-037_B
|       |-- outs/
|       |-- SPATIAL_RNA_COUNTER_CS/
|       |-- V52L26-037_B.mri.tgz
|       └-- ...
└── ...
```
