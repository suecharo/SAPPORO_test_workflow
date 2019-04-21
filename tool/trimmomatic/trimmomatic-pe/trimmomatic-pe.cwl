#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
requirements:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/trimmomatic:0.38--1
baseCommand: trimmomatic
arguments:
  - position: 0
    valueFrom: PE
  - position: 4
    valueFrom: $(inputs.fastq_1.nameroot).trimed.1P.fastq
  - position: 5
    valueFrom: $(inputs.fastq_1.nameroot).trimed.1U.fastq
  - position: 6
    valueFrom: $(inputs.fastq_1.nameroot).trimed.2P.fastq
  - position: 7
    valueFrom: $(inputs.fastq_1.nameroot).trimed.2U.fastq
  - position: 8
    valueFrom: ILLUMINACLIP:/usr/local/share/trimmomatic/adapters/TruSeq2-PE.fa:2:40:15
  - position: 9
    valueFrom: LEADING:20
  - position: 10
    valueFrom: TRAILING:20
  - position: 11
    valueFrom: SLIDINGWINDOW:4:15
  - position: 12
    valueFrom: MINLEN:36
inputs:
  nthreads:
    type: int?
    default: 2
    inputBinding:
      position: 1
      prefix: -threads
  fastq_1:
    type: File
    inputBinding:
      position: 2
  fastq_2:
    type: File
    inputBinding:
      position: 3
outputs:
  trimed_fastq1P:
    type: File
    outputBinding:
      glob: $(inputs.fastq_1.nameroot).trimed.1P.fastq
  trimed_fastq1U:
    type: File
    outputBinding:
      glob: $(inputs.fastq_1.nameroot).trimed.1U.fastq
  trimed_fastq2P:
    type: File
    outputBinding:
      glob: $(inputs.fastq_1.nameroot).trimed.2P.fastq
  trimed_fastq2U:
    type: File
    outputBinding:
      glob: $(inputs.fastq_1.nameroot).trimed.2U.fastq
  stdout: stdout
  stderr: stderr
stdout: trimmomatic-pe-stdout.log
stderr: trimmomatic-pe-stderr.log