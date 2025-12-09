# IBBC Bash Scripting Evaluation 

Este projeto teve como objetivo desenvolver um pipeline automatizado e reprodutível para processamento de dados de sequenciação paired-end.

## Estrutura do projeto

```bash
Project_ibbc_Adilcia/
├── config.sh
├── 01_setup_project.sh
├── 02_run_pipeline.sh
├── 03_extra_utility.sh
├── raw_data/              
├── results/
│   ├── clean/
│   ├── qc/
│   ├── organelle/
└── README.md
```

## Ferramentas utilizadas
- fastp: Limpeza e filtragem de leituras (remoção de sequências de baixa qualidade)
- fastqc: Controlo de qualidade (pré e pós trimming)
- getorganelle: Montagem do genoma organelar
- conda: Gestão do ambiente e dependências

## Scripts implementados
- 01_setup_project.sh: cria toda a estrutura de diretórios e verifica ferramentas instaladas.
- 02_run_pipeline.sh: Pipeline completo.
  Processamento/Deteção automático das amostras → Fastp → FastQC → GetOrganelle
- 03_extra_utility.sh: gera uma tabela final com informação comparativa e sucesso da montagem.
  Output: results/summary_table.tvs
- config.sh: define parâmetros usados por todos os scripts.

## Execução do pipeline no terminal
1. Entrar na pasta do projeto:
   ```bash
   cd Project_ibbc_Adilcia
   ```
3. Configuração do ambiente e ativação do ambiente conda:
   ```bash
   conda create -n ibbc_eval -c conda-forge -c bioconda fastp fastqc getorganelle
   conda activate ibbc_eval
   ```
5. Criação de diretória para FASTQ:
   mkdir raw_data
6. Verificação das amostras:
   ls raw_data/
7. Preparação do projeto:
   ./01_setup_project.sh config.sh
8. Execução do pipeline:
   ./02_run_pipeline.sh config.sh
9. Verificação de resultados*:
    ls results/clean/
    ls results/qc/
    ls results/organelle/
10. Obtenção do resumo:
   ./03_extra_utility.sh config.sh
   column -t -s $'\t' results/summary_table.tsv

## *Outputs principais
- FASTQ limpos → results/clean/
- FastQC antes/depois → results/qc/
- Montagem organelar → results/organelle/nome_sample/
- Tabela resumo → results/summary_table.tsv

## Conclusão
Este projeto demonstra competências fundamentais em Bioinformática como automação e tratamento de dados NGS (Nova Geração de Sequenciamento).O pipeline garante reprodutibilidade,facilidade de execução, organização de dados e escalabilidade para múltiplas amostras.

Autora: **Adilcia d'Alva**
