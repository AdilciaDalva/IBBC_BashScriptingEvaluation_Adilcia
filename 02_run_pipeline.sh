#!/usr/bin/env bash

# ===========================
# 02_run_pipeline.sh
# Pipeline principal IBBC
# ===========================

CONFIG=$1
source "$CONFIG"

MASTER_LOG="results/logs/pipeline_master.log"
mkdir -p results/logs

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Início do pipeline" | tee -a "$MASTER_LOG"


# =======================================
# DETETAR AMOSTRAS AUTOMATICAMENTE
# =======================================
SAMPLES=()
for R1 in raw_data/*_R1.fastq.gz; do
    SAMPLE=$(basename "$R1" | sed 's/_R1.fastq.gz//')
    SAMPLES+=("$SAMPLE")
done


# =======================================
# SUPORTAR FILTRAGEM POR ARGUMENTO
# ./02_run_pipeline.sh config.sh --samples "SCw13_R1.fastq.gz"
# =======================================
if [[ "$2" == "--samples" ]]; then
    SELECTED=$(basename "$3" | sed 's/_R1.fastq.gz//')
    SAMPLES=("$SELECTED")
fi


# =======================================
# LOOP DO PIPELINE
# =======================================
for SAMPLE in "${SAMPLES[@]}"; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] PROCESSING $SAMPLE" | tee -a "$MASTER_LOG"

    R1="raw_data/${SAMPLE}_R1.fastq.gz"
    R2="raw_data/${SAMPLE}_R2.fastq.gz"

    OUT_R1="results/clean/${SAMPLE}_R1.clean.fastq.gz"
    OUT_R2="results/clean/${SAMPLE}_R2.clean.fastq.gz"

    mkdir -p results/clean results/qc results/organelle/${SAMPLE}

    # FASTP
    echo "FASTP → $SAMPLE"
    fastp -i "$R1" -I "$R2" \
          -o "$OUT_R1" -O "$OUT_R2" \
          -w "$THREADS" \
          > "results/logs/${SAMPLE}_fastp.log" 2>&1

    # FASTQC
    echo "FASTQC → $SAMPLE"
    fastqc "$OUT_R1" "$OUT_R2" \
           -o results/qc/ \
           >> "results/logs/${SAMPLE}_fastqc.log" 2>&1

    # GETORGANELLE
    echo "GETORGANELLE → $SAMPLE"
    getorganelle_from_reads.py -1 "$OUT_R1" -2 "$OUT_R2" \
        -o "results/organelle/${SAMPLE}" \
        -t "$THREADS" -F "$GETO_DB" \
        > "results/logs/${SAMPLE}_getorganelle.log" 2>&1

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] DONE $SAMPLE" | tee -a "$MASTER_LOG"
done


# =======================================
# MULTIQC FINAL
# =======================================
echo "MULTIQC → results/multiqc_report/"
multiqc results -o results/multiqc_report/ \
       >> "$MASTER_LOG" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] PIPELINE FINALIZADO" | tee -a "$MASTER_LOG"
