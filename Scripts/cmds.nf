#!/usr/bin/env nextflow

//use nextflow dsl2
nextflow.enable.dsl=2

//process for running fastp cleaning
process fastp {
    publishDir './', mode: 'copy'
    tag "$srr_id"

    //input files for fastp
    input:
    tuple val(srr_id), path(read1), path(read2)

    //output files for fastp
    output:
    tuple val(srr_id), path("./${srr_id}_1_trimmed.fastq"), path("./${srr_id}_2_trimmed.fastq")

    //use fastp v 0.23.4
    conda 'bioconda::fastp=0.23.4'

    //script for running fastp
    script:
    """
    fastp -i ${read1} -I ${read2} -o ${srr_id}_1_trimmed.fastq -O ${srr_id}_2_trimmed.fastq
    """
}

//process for running spades assembly
process spades {
    publishDir './', mode: 'copy'
    tag "$srr_id"

    //input files for spades
    input:
    tuple val(srr_id), path(qc_read1), path(qc_read2)

    //output files for spades
    output:
    path("${srr_id}_assembly")

    //use spades v 4.1.0
    conda 'bioconda::spades=4.1.0'

    //script for running spades
    script:
    """
    spades.py \
    -1 ${qc_read1} \
    -2 ${qc_read2} \
    -o ${srr_id}_assembly \
    --only-assembler
    """
}

//process for running seqkit metrics
process seqkit {
    publishDir './', mode: 'copy'
    tag "$srr_id"

    //input files for seqkit
    input:
    tuple val(srr_id), path(qc_read1), path(qc_read2)

    //output files for seqkit
    output:
    path("${srr_id}_read_metrics.txt")

    //use seqkit v 2.10.0
    conda 'bioconda::seqkit=2.10.0'

    //script for running seqkit
    script:
    """
    seqkit stats ${qc_read1} > ${srr_id}_read1_stats.txt
    seqkit stats ${qc_read2} > ${srr_id}_read2_stats.txt
    cat ${srr_id}_read1_stats.txt ${srr_id}_read2_stats.txt > ${srr_id}_read_metrics.txt
    """
}


//run workflow and execute all 3 processes
workflow {
    samples = Channel.fromFilePairs('./SRR*_{1,2}.fastq.gz', flat: true)
    qc_samples = fastp(samples)
    spades(qc_samples)
    seqkit(qc_samples)
}
