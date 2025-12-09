# config.sh - configuração principal do pipeline

# Diretório com os ficheiros FASTQ
RAW_DIR="raw_data"

# Diretório com os resultados
OUTDIR="results"

# Subdiretórios
CLEAN_DIR="${OUTDIR}/clean"
QC_DIR="${OUTDIR}/qc"
ORG_DIR="${OUTDIR}/organelle"
LOG_DIR="${OUTDIR}/logs"

# Ferramentas — assumimos que estarão instaladas no sistema
FASTP_CMD="fastp"
FASTQC_CMD="fastqc"
GETORGANELLE_CMD="getorganelle_from_reads.py"
MULTIQC_CMD="multiqc"

# Número de threads
THREADS=4

# Tipo de genoma de organelo ~ pode ser alterado
GETO_DB="plant_cp"

# Logs
MASTER_LOG="${LOG_DIR}/pipeline_master.log"

# Comportamento
FORCE=false
KEEP_INTERMEDIATES=false
