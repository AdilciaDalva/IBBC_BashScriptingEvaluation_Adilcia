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
│   ├── logs/
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
- config.sh: cérebro da configuração, basicamente defime todos os parâmetros usados por todos os scripts

## Execução do pipeline no terminal
1. Entrar na pasta do projeto:
   ```bash
   cd Project_ibbc_Adilcia
   ```
2. Configuração do ambiente e ativação do ambiente conda:
   ```bash
   conda create -n ibbc_eval -c conda-forge -c bioconda fastp fastqc getorganelle
   conda activate ibbc_eval
   ```
3. Criação de diretória para FASTQ:
   ```bash
   mkdir raw_data
   ```
4. Verificação das amostras:
   ```bash
   ls raw_data/
   ```
5. Preparação do projeto:
   ```bash
   ./01_setup_project.sh
   ````
6. Execução do pipeline:
    ```bash
   ./02_run_pipeline.sh
    ```
7. Verificação de resultados*:
    ```bash
    ls results/clean/
    ls results/qc/
    ls results/organelle/
    ls results/logs
    ```
8. Obtenção do resumo:
   ```bash
   ./03_extra_utility.sh config.sh
   cat results/summary_table.tsv
    ```

## *Outputs principais
- FASTQ limpos → results/clean/
- FastQC antes/depois → results/qc/
- Montagem organelar → results/organelle/nome_sample/
- Tabela resumo → results/summary_table.tsv

## Conclusão
Este projeto demonstra competências fundamentais em Bioinformática como automação e tratamento de dados NGS (Nova Geração de Sequenciamento).O pipeline garante reprodutibilidade,facilidade de execução, organização de dados e escalabilidade para múltiplas amostras.

Autora: **Adilcia d'Alva**
