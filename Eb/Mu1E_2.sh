#!/bin/bash

# Define the Python script filename
PYTHON_FILE="Mu1E_2.py"

# Extract parameter values using grep and cut
Nlinker=$(grep '^Nlinker\s*=' $PYTHON_FILE | cut -d '=' -f2 | tr -d '[:space:]')
ell_tot=$(grep '^ell_tot\s*=' $PYTHON_FILE | cut -d '=' -f2 | tr -d '[:space:]')
kdiff=$(grep '^kdiff\s*=' $PYTHON_FILE | cut -d '=' -f2 | tr -d '[:space:]')
Energy=$(grep '^Energy\s*=' $PYTHON_FILE | cut -d '=' -f2 | tr -d '[:space:]')

# Python code to format the parameters into a file name
FORMAT_SCRIPT=$(cat <<EOF
def scientific_format(num):
    if num == 0:
        return "0"
    sci_notation = f"{num:.0e}".split('e')
    coefficient = int(sci_notation[0])
    exponent = int(sci_notation[1])
    if exponent == 0:
        return f"{coefficient}"
    elif coefficient == 1:
        return f"E{exponent}"
    else:
        return f"{coefficient}E{exponent}"

nlinker_formatted = f"N{$Nlinker}"
energy_formatted = f"E{$Energy}"
ell_tot_formatted = f"ell{scientific_format(float($ell_tot))}"
kdiff_formatted = f"kdiff{scientific_format(float($kdiff))}"

result = f"{energy_formatted}_{nlinker_formatted}_{ell_tot_formatted}_{kdiff_formatted}"
print(result)
EOF
)

# Execute Python script and capture output into a Bash variable
formatted_output=$(python3 -c "$FORMAT_SCRIPT")
sbatch <<EOT
#!/bin/bash
#SBATCH --job-name="$formatted_output"
#SBATCH --output=logs/${formatted_output}_output.txt
#SBATCH --error=logs/${formatted_output}_error.txt
#SBATCH --time=50:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=2G

# Load the module
module load gcc python

# Activate the virtual environment
source /home/hcleroy/venvs/base/bin/activate

# Run your Python script
srun python $PYTHON_FILE $formatted_output

deactivate
EOT
