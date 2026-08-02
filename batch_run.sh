#!/bin/bash
#SBATCH --job-name=thesis_experiment1
#SBATCH --output=slurm-%A_%a.out
#SBATCH --error=slurm-%A_%a.err
#SBATCH --time=20:00:00
#SBATCH --mem=28GB
#SBATCH --cpus-per-task=16
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --array=1-10%10        # adjust to ceil(TOTAL_LINES / BATCH_SIZE)
#SBATCH --partition=rome

module purge
module load 2024
module load SciPy-bundle/2024.05-gfbf-2024a

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

cd "network_structures/" || { echo "ERROR: Directory 'network_structures/' not found."; exit 1; }
mkdir -p results_snellius

PARAMS_FILE="params_networks.txt"
BATCH_SIZE=60
TOTAL_LINES=$(wc -l < "$PARAMS_FILE")
START=$(( (SLURM_ARRAY_TASK_ID - 1) * BATCH_SIZE + 1 ))
END=$(( SLURM_ARRAY_TASK_ID * BATCH_SIZE ))
END=$(( END > TOTAL_LINES ? TOTAL_LINES : END ))

echo "[$(date '+%F %T')] Task $SLURM_ARRAY_TASK_ID: processing lines $START–$END"

CMDS_FILE=$(mktemp)
awk -v start="$START" -v end="$END" '
  NR >= start && NR <= end {
    gsub(/\r/, "")
    group=$1; turn=$2; pop=$3; net=$4; mode=$5; run=$6; rep=$7; alpha=$8
    print "python sim_extra_baseline.py" \
          " --mode "               mode  \
          " --group_round "        group \
          " --turnover_round "     turn  \
          " --pop_size "           pop   \
          " --run_id "             run   \
          " --network_type "       net   \
          " --replace "            rep   \
          " --alpha "              alpha \
          " > results_snellius/out_" NR ".txt 2>&1"
  }
' "$PARAMS_FILE" > "$CMDS_FILE"

xargs -a "$CMDS_FILE" -d '\n' -P "$SLURM_CPUS_PER_TASK" -I{} bash -c {}
rm "$CMDS_FILE"

echo "[$(date '+%F %T')] Task $SLURM_ARRAY_TASK_ID complete."