#!/bin/bash
#SBATCH --job-name=Mu1E_2_N100_job
#SBATCH --output=logs/Mu1E_3_output_%j.txt
#SBATCH --error=logs/Mu1E_3_error_%j.txt
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=1G

# Load the module
module load gcc python

# Activate the virtual environment
source /home/hcleroy/venvs/base/bin/activate

# Run your Python script
srun python mu1e_3.py

deactivate
