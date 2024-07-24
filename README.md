# Space Ranger SLURM Job Queueing Script

This repository contains a script to streamline the process of queuing Space Ranger jobs for multiple samples on a SLURM-based high-performance computing (HPC) cluster. Space Ranger (10x Genomics) used for processing Visium spatial gene expression data.

## Usage

### Setup

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
# >>> spaceranger-scripts>>>
# !! Contents within this block was added by 'init.sh' from spaceranger-scripts !!
export PATH="$PATH:/path/to/spaceranger-scripts/scripts"
# <<< spaceranger-scripts <<<
```

### Input requirement

#### One directory for both images

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
│   ├── *V52L26-037_A_alignment.json* *(if manual align)*
│   ├── V52L26-037_B_HE.tif
│   ├── V52L26-037_B_Cyt.tif
│   ├── *V52L26-037_B_alignment.json* *(if manual align)*
│   └── ...
└── spaceranger_out/

#### Seperate directories for images

project/ 
├── fastq/ 
│   ├── V52L26-037_A_S1_R1_001.fastq.gz
│   ├── V52L26-037_A_S1_R2_001.fastq.gz
│   ├── V52L26-037_B_S2_R1_001.fastq.gz
│   ├── V52L26-037_B_S2_R2_001.fastq.gz
│   `── ...
├── he/
│   ├── V52L26-037_A.tif
│   ├── V52L26-037_B.tif
│   `── ...
├── cytassist/
│   ├── V52L26-037_A.tif
│   ├── *V52L26-037_A_alignment.json* *(if manual align)*
│   ├── V52L26-037_B.tif
│   ├── *V52L26-037_B_alignment.json* *(if manual align)*
│   `── ...
`── spaceranger_out/

### Running the script

## Output example

spaceranger_out/ 
├── V52L26-037_A
|   |-- job-73311.err
|   |-- job-73311.out
|   `-- V52L26-037_A
|       |-- _cmdline
|       |-- _filelist
|       |-- _finalstate
|       |-- _invocation
|       |-- _jobmode
|       |-- _log
|       |-- _mrosource
|       |-- outs
|       |-- _perf
|       |-- _perf._truncated_
|       |-- _sitecheck
|       |-- SPATIAL_RNA_COUNTER_CS
|       |-- _tags
|       |-- _timestamp
|       |-- _uuid
|       |-- V52L26-037_A.mri.tgz
|       |-- _vdrkill
|       `-- _versions
├── V52L26-037_B
|   |-- job-73312.err
|   |-- job-73312.out
|   `-- V52L26-037_B
|       |-- _cmdline
|       |-- _filelist
|       |-- _finalstate
|       |-- _invocation
|       |-- _jobmode
|       |-- _log
|       |-- _mrosource
|       |-- outs
|       |-- _perf
|       |-- _perf._truncated_
|       |-- _sitecheck
|       |-- SPATIAL_RNA_COUNTER_CS
|       |-- _tags
|       |-- _timestamp
|       |-- _uuid
|       |-- V52L26-037_B.mri.tgz
|       |-- _vdrkill
|       `-- _versions
└── ...

