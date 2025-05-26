# QC_Workflow

This nextflow pipeline performs sequential read quality control and genome assembly while also analyzing the quality-filtered reads in parallel.

Specifically, the workflow:

1. Trims reads using fastp

2a. Assembles paired reads using spades

2b. generates read statistics using seqkit 

## Workflow Diagram

<img width="1147" alt="workflowdiagram" src="https://github.gatech.edu/hmiura3/first_wf/assets/97627/024c0e9a-0147-4aab-8d04-c08dfc57efb1">

## Requirements

### Nextflow and Package Manager Version

You must have conda installed, and run the script in a conda environment where nextflow is present.

New conda environment for this script can be created using `conda create -n nf -c bioconda nextflow -y`

`Nextflow -- version 24.10.5`

`Conda ----- version 25.1.1`


### Architecture

`OS: macOS 15.3.1`

`Architecture: arm64`



### Tools Used (satisfied within nextflow process)

`Fastp ---- v0.23.4`

`Spades --- v4.1.0`

`Seqkit --- v2.10.0`


## Data Description:

Make sure that all files below are contained within the same working directory.

To run the workflow, use command  `nextflow run cmds.nf`


`Script`: contains nextflow.contig and cmds.nf that are used to run the nextflow commands

`test_data`: contains the link to dropbox containing fastq paired reads used for testing
