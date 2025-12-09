#!/usr/bin/env bash
set -euo pipefail

CONFIG="${1:-config.sh}"

if [[ ! -f "$CONFIG" ]]; then
  echo "Ficheiro de configuração '$CONFIG' não encontrado."
  exit 1
fi

source "$CONFIG"

echo "A criar diretórios de saída..."
mkdir -p "$RAW_DIR" "$CLEAN_DIR" "$QC_DIR" "$ORG_DIR" "$LOG_DIR"

check_tool() {
  if ! command -v "$1" &>/dev/null; then
    echo "FERRAMENTA EM FALTA: $1"
    return 1
  fi
}

missing=false
for tool in "$FASTP_CMD" "$FASTQC_CMD" "$GETORGANELLE_CMD" "$MULTIQC_CMD"; do
  check_tool "$tool" || missing=true
done

if $missing; then
  echo "Instala as ferramentas necessárias para continuar."
else
  echo "Tudo pronto! Ambiente configurado com sucesso."
fi
