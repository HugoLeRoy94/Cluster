#!/bin/bash
#SBATCH --job-name=Mu1E_1_N100_job
#SBATCH --output=logs/Mu5E_2_output_%j.txt
#SBATCH --error=logsMu5E_2_error_%j.txt
#SBATCH --time=48:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=1G

# Load the module
module load gcc python

# Activate the virtual environment
source /home/hcleroy/venvs/base/bin/activate

# Run your Python script
srun python mu5e_2.py

deactivate
