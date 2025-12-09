#!/usr/bin/env bash
set -euo pipefail

CONFIG="${1:-config.sh}"

if [[ ! -f "$CONFIG" ]]; then
  echo "Configuração '$CONFIG' não encontrada!"
  exit 1
fi

source "$CONFIG"

echo "A gerar resumo → ${OUTDIR}/summary_table.tsv"

{
  echo -e "sample\traw_R1_bytes\traw_R2_bytes\tclean_R1_bytes\tclean_R2_bytes\tgetorganelle_success"

  for r1 in ${RAW_DIR}/*_R1*.fastq.gz; do
    SAMPLE=$(basename "$r1" | sed -E 's/_R1.*//')
    r2="${RAW_DIR}/${SAMPLE}_R2.fastq.gz"

    raw1=$(stat -c%s "$r1")
    raw2=$(stat -c%s "$r2")

    c1="${CLEAN_DIR}/${SAMPLE}_R1.clean.fastq.gz"
    c2="${CLEAN_DIR}/${SAMPLE}_R2.clean.fastq.gz"

    clean1=$(stat -c%s "$c1")
    clean2=$(stat -c%s "$c2")

    if [[ -f "${ORG_DIR}/${SAMPLE}/getorganelle.stdout" ]]; then
      status="yes"
    else
      status="no"
    fi

    echo -e "${SAMPLE}\t${raw1}\t${raw2}\t${clean1}\t${clean2}\t${status}"
  done
} > "${OUTDIR}/summary_table.tsv"

echo "Resumo criado com sucesso!"
