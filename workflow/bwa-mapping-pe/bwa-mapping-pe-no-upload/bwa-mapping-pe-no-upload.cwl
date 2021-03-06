#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
doc: BWA-mapping-PE is a mapping workflow using BWA for Peared-end reads. It receives two fastq files and one reference genome. Please enter download link of fastq files and reference genome. The reference genome will be indexed by BWA. Trimming, QC and bam sort will do too. QC result and sam / bam file will be output.
inputs:
  fastq_1:
    type: File
    label: Fastq file from next generation sequencer
  fastq_2:
    type: File
    label: Fastq file from next generation sequencer
  fasta:
    type: File
    label: Fasta file
  nthreads:
    type: int?
    default: 2
    label: (optional) Number of cpu cores to be used
steps:
  qc_fastq_1:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/fastqc/fastqc.cwl
    in:
      nthreads: nthreads
      fastq: fastq_1
    out:
      - qc_result
      - stdout
      - stderr
  qc_fastq_2:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/fastqc/fastqc.cwl
    in:
      nthreads: nthreads
      fastq: fastq_2
    out:
      - qc_result
      - stdout
      - stderr
  trimming:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/trimmomatic/trimmomatic-pe/trimmomatic-pe.cwl
    in:
      nthreads: nthreads
      fastq_1: fastq_1
      fastq_2: fastq_2
    out:
      - trimmed_fastq1P
      - trimmed_fastq1U
      - trimmed_fastq2P
      - trimmed_fastq2U
      - stdout
      - stderr
  qc_trimmed_fastq_1:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/fastqc/fastqc.cwl
    in:
      nthreads: nthreads
      fastq: trimming/trimmed_fastq1P
    out:
      - qc_result
      - stdout
      - stderr
  qc_trimmed_fastq_2:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/fastqc/fastqc.cwl
    in:
      nthreads: nthreads
      fastq: trimming/trimmed_fastq2P
    out:
      - qc_result
      - stdout
      - stderr
  bwa-index-build:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/bwa/bwa-index/bwa-index.cwl
    in:
      fasta: fasta
    out:
      - amb
      - ann
      - bwt
      - pac
      - sa
      - stdout
      - stderr
  bwa-mapping:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/bwa/bwa-mapping-pe/bwa-mapping-pe.cwl
    in:
      nthreads: nthreads
      fasta: fasta
      amb: bwa-index-build/amb
      ann: bwa-index-build/ann
      bwt: bwa-index-build/bwt
      pac: bwa-index-build/pac
      sa: bwa-index-build/sa
      fastq_1: trimming/trimmed_fastq1P
      fastq_2: trimming/trimmed_fastq2P
    out:
      - sam
      - stderr
  sam2bam:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/samtools/samtools-sam2bam/samtools-sam2bam.cwl
    in:
      sam: bwa-mapping/sam
    out:
      - bam
      - stderr
  mark-duplicates:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/picard/picard-mark-duplicates/picard-mark-duplicates.cwl
    in:
      bam: sam2bam/bam
    out:
      - marked_bam
      - metrix
      - stdout
      - stderr
  sort-bam:
    run: https://raw.githubusercontent.com/ddbj/SAPPORO_test_workflow/master/tool/picard/picard-sort-bam/picard-sort-bam.cwl
    in:
      bam: mark-duplicates/marked_bam
    out:
      - sorted_bam
      - stdout
      - stderr
outputs:
  qc_fastq_1_result:
    type: File
    outputSource: qc_fastq_1/qc_result
  qc_fastq_2_result:
    type: File
    outputSource: qc_fastq_2/qc_result
  trimming_trimmed_fastq1P:
    type: File
    outputSource: trimming/trimmed_fastq1P
  trimming_trimmed_fastq1U:
    type: File
    outputSource: trimming/trimmed_fastq1U
  trimming_trimmed_fastq2P:
    type: File
    outputSource: trimming/trimmed_fastq2P
  trimming_trimmed_fastq2U:
    type: File
    outputSource: trimming/trimmed_fastq2U
  qc_trimmed_fastq_1_result:
    type: File
    outputSource: qc_trimmed_fastq_1/qc_result
  qc_trimmed_fastq_2_result:
    type: File
    outputSource: qc_trimmed_fastq_2/qc_result
  bwa-index-build_amb:
    type: File
    outputSource: bwa-index-build/amb
  bwa-index-build_ann:
    type: File
    outputSource: bwa-index-build/ann
  bwa-index-build_bwt:
    type: File
    outputSource: bwa-index-build/bwt
  bwa-index-build_pac:
    type: File
    outputSource: bwa-index-build/pac
  bwa-index-build_sa:
    type: File
    outputSource: bwa-index-build/sa
  bwa-mapping_sam:
    type: File
    outputSource: bwa-mapping/sam
  sam2bam_bam:
    type: File
    outputSource: sam2bam/bam
  mark-duplicates_marked_bam:
    type: File
    outputSource: mark-duplicates/marked_bam
  mark-duplicates_metrix:
    type: File
    outputSource: mark-duplicates/metrix
  sort-bam_sorted_bam:
    type: File
    outputSource: sort-bam/sorted_bam
