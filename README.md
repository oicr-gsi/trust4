# trust4

Tcr Receptor Utilities for Solid Tissue (TRUST) is a computational tool to analyze TCR and BCR sequences using unselected RNA sequencing data, profiled from solid tissues, including tumors. TRUST4 performs de novo assembly on V, J, C genes including the hypervariable complementarity-determining region 3 (CDR3) and reports consensus of BCR/TCR sequences. TRUST4 then realigns the contigs to IMGT reference gene sequences to report the corresponding information.

## Dependencies

* [trust4 1.0.5.1](https://github.com/liulab-dfci/TRUST4)


## Usage

### Cromwell
```
java -jar cromwell.jar run trust4.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`fastqR1`|File|Input file with the first mate reads.
`fastqR2`|File|Input file with the second mate reads.
`runTrust4.bcrtcrFasta`|String|BCR TCR fasta
`runTrust4.refIMGT`|String|Detailed .fa with chromosomal coordinates, IMGT: http://www.imgt.org//download/V-QUEST/IMGT_V-QUEST_reference_directory/


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`outputFileNamePrefix`|String|""|Output prefix, customizable. Default is the first file's basename.


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`runTrust4.jobMemory`|Int|8|Memory allocated to the task.
`runTrust4.timeout`|Int|20|Timeout in hours, needed to override imposed limits.
`runTrust4.threads`|Int?|None|Optional threads, default is 1
`runTrust4.modules`|String|"mixcr/3.0.13"|Names and versions of required modules.


### Outputs

Output | Type | Description
---|---|---
`cdrReport`|File|report contains CDR1,2,3 and gene information for each consensus assemblies
`finalContigs`|File|contigs and corresponding nucleotide weight
`finalReport`|File|report file focusing on CDR3 and is compatible with other repertoire analysis tool such as VDJTools
`consensusAssembly`|File|fasta file for the annotation of the consensus assembly


## Commands
 This section lists command(s) run by trust4 workflow
 
 * Running trust4
 
 ### TRUST4 runs a single command which produces a number of outputs which should be analyzed in a downstream process 
 
 ```
 
  set -euo pipefail
  run-trust4 -f BCRTCR.fa [--ref refIMGT.fa] [-t THREADS] -1 FASTQ_R1 -2 FASTQ_R2 -o OUTPUT_PREFIX 
 
 ```
 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
