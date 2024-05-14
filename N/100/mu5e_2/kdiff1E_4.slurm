#!/bin/bash
#SBATCH --job-name=mu5E_2_N100_kdiff1E_4
#SBATCH --output=logs/kdiffE_4%j.txt
#SBATCH --error=logs/kdiffE_4%j.txt
#SBATCH --time=100:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=1G

# Load the module
module load gcc python

# Activate the virtual environment
source /home/hcleroy/venvs/base/bin/activate

# Run your Python script
srun python kdiff1E_4.py

deactivate
