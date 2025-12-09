#!/usr/bin/env bash
set -euo pipefail

CONFIG="${1:-config.sh}"

if [[ ! -f "$CONFIG" ]]; then
  echo "Configuração '$CONFIG' não encontrada."
  exit 1
fi

source "$CONFIG"

TIMESTAMP() { date +"%Y-%m-%d %H:%M:%S"; }

echo "[$(TIMESTAMP)] Início do pipeline" | tee -a "$MASTER_LOG"

shopt -s nullglob
R1_FILES=(${RAW_DIR}/*_R1*.fastq.gz)
shopt -u nullglob

if [[ ${#R1_FILES[@]} -eq 0 ]]; then
  echo "Nenhum ficheiro R1 encontrado em $RAW_DIR"
  exit 1
fi

for r1 in "${R1_FILES[@]}"; do
  SAMPLE=$(basename "$r1" | sed -E 's/_R1.*//')
  R2="${RAW_DIR}/${SAMPLE}_R2.fastq.gz"

  if [[ ! -f "$R2" ]]; then
    echo "⚠️  Sem ficheiro par R2 para $SAMPLE → ignorar"
    continue
  fi

  echo "[$(TIMESTAMP)] PROCESSING $SAMPLE" | tee -a "$MASTER_LOG"

  OUT_R1="${CLEAN_DIR}/${SAMPLE}_R1.clean.fastq.gz"
  OUT_R2="${CLEAN_DIR}/${SAMPLE}_R2.clean.fastq.gz"

  echo "FASTP → $SAMPLE"
  $FASTP_CMD -i "$r1" -I "$R2" -o "$OUT_R1" -O "$OUT_R2" -w "$THREADS" \
    >> "$LOG_DIR/${SAMPLE}.fastp.log" 2>&1

  echo "FASTQC → $SAMPLE"
  $FASTQC_CMD "$OUT_R1" "$OUT_R2" -o "$QC_DIR" -t "$THREADS" \
    >> "$LOG_DIR/${SAMPLE}.fastqc.log" 2>&1

  echo "GETORGANELLE → $SAMPLE"
  $GETORGANELLE_CMD -1 "$OUT_R1" -2 "$OUT_R2" -o "$ORG_DIR/$SAMPLE" -t "$THREADS" -F "$GETO_DB" \
    > "$ORG_DIR/$SAMPLE/getorganelle.stdout" 2> "$ORG_DIR/$SAMPLE/getorganelle.stderr"

  echo "[$(TIMESTAMP)] DONE $SAMPLE" | tee -a "$MASTER_LOG"
done

echo "MultiQC → a gerar relatório..."
$MULTIQC_CMD "$OUTDIR" -o "${OUTDIR}/multiqc_report" >> "$MASTER_LOG" 2>&1

echo "[$(TIMESTAMP)] PIPELINE FINALIZADO" | tee -a "$MASTER_LOG"
