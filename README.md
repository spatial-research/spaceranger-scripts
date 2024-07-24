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

project-root/ ├── bin/ │ ├── script1.sh │ └── script2.sh ├── data/ │ ├── raw/ │ │ ├── data1.csv │ │ └── data2.csv │ └── processed/ │ ├── data1_processed.csv │ └── data2_processed.csv ├── docs/ │ ├── README.md │ └── manual.pdf ├── src/ │ ├── main.py │ ├── module1.py │ └── module2.py ├── tests/ │ ├── test_main.py │ └── test_module1.py ├── .gitignore ├── requirements.txt └── setup.py

### Running the script

