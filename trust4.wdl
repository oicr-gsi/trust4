version 1.0

struct trustResources {
    String refIMGT
    String bcrtcrFasta
}

# ================================================================================
# Workflow accepts two fastq files for paired-end sequencing, with R1 and R2 reads
# ================================================================================
workflow trust4 {
input {
  File  fastqR1 
  File  fastqR2
  String reference
  String outputFileNamePrefix = ""
}

String sampleID = if outputFileNamePrefix=="" then basename(fastqR1, ".fastq.gz") else outputFileNamePrefix

Map[String,trustResources] trust_res_by_genome = {
    "hg19": {
       "refIMGT": "$TRUST4_ROOT/human_IMGT+C.fa",
       "bcrtcrFasta": "$TRUST4_ROOT/hg19_bcrtcr.fa"
    },
    "hg38": {
       "refIMGT": "$TRUST4_ROOT/human_IMGT+C.fa",
       "bcrtcrFasta": "$TRUST4_ROOT/hg38_bcrtcr.fa"
    },
    "mm10": {
       "refIMGT": "$TRUST4_ROOT/mouse/mouse_IMGT+C.fa",
       "bcrtcrFasta": "$TRUST4_ROOT/mouse/GRCm38_bcrtcr.fa"
    }      
}

call runTrust4 {input: fastqR1 = fastqR1, 
                       fastqR2 = fastqR2,
                       refIMGT = trust_res_by_genome[reference].refIMGT,
                       bcrtcrFasta  = trust_res_by_genome[reference].bcrtcrFasta,
                       outputPrefix = sampleID}

parameter_meta {
  fastqR1: "Input file with the first mate reads."
  fastqR2: "Input file with the second mate reads."
  reference: "Reference assembly id"
  outputFileNamePrefix: "Output prefix, customizable. Default is the first file's basename."
}

meta {
    author: "Peter Ruzanov"
    email: "peter.ruzanov@oicr.on.ca"
    description: "Tcr Receptor Utilities for Solid Tissue (TRUST) is a computational tool to analyze TCR and BCR sequences using unselected RNA sequencing data, profiled from solid tissues, including tumors. TRUST4 performs de novo assembly on V, J, C genes including the hypervariable complementarity-determining region 3 (CDR3) and reports consensus of BCR/TCR sequences. TRUST4 then realigns the contigs to IMGT reference gene sequences to report the corresponding information."
    dependencies: [
      {
        name: "trust4/1.0.5.1",
        url: "https://github.com/liulab-dfci/TRUST4"
      }
    ]
    output_meta: {
    cdrReport: {
        description: "report contains CDR1,2,3 and gene information for each consensus assemblies",
        vidarr_label: "cdrReport"
    },
    finalContigs: {
        description: "contigs and corresponding nucleotide weight",
        vidarr_label: "finalContigs"
    },
    finalReport: {
        description: "report file focusing on CDR3 and is compatible with other repertoire analysis tool such as VDJTools",
        vidarr_label: "finalReport"
    },
    consensusAssembly: {
        description: "fasta file for the annotation of the consensus assembly",
        vidarr_label: "consensusAssembly"
    }
}
}


output {
  File cdrReport     = runTrust4.cdrReport
  File finalContigs  = runTrust4.finalContigs
  File finalReport   = runTrust4.finalReport
  File consensusAssembly = runTrust4.consensusAssembly
}
}

# ==============================
#    TRUST4 SINGLE-STEP ANALYSIS
# ==============================
task runTrust4 {
input {
  Int  jobMemory = 8
  Int  timeout   = 20
  Int? threads
  String bcrtcrFasta 
  String outputPrefix
  String refIMGT
  File fastqR1
  File fastqR2
  String modules = "mixcr/3.0.13"
}

command <<<
 set -euo pipefail
 run-trust4 -f ~{bcrtcrFasta} ~{"--ref " + refIMGT} ~{"-t " + threads} -1 ~{fastqR1} -2 ~{fastqR2} -o ~{outputPrefix} 
>>>

parameter_meta {
 jobMemory: "Memory allocated to the task."
 timeout: "Timeout in hours, needed to override imposed limits."
 bcrtcrFasta: "BCR TCR fasta"
 outputPrefix: "Custom output for result files"
 refIMGT: "Detailed .fa with chromosomal coordinates, IMGT: http://www.imgt.org//download/V-QUEST/IMGT_V-QUEST_reference_directory/"
 threads: "Optional threads, default is 1"
 modules: "Names and versions of required modules."
 fastqR1: "Input fastq R1."
 fastqR2: "Input fastq R2."
}

runtime {
  memory:  "~{jobMemory} GB"
  modules: "~{modules}"
  timeout: "~{timeout}"
}

output {
  File cdrReport = "~{outputPrefix}_cdr3.out"
  File finalContigs = "~{outputPrefix}_final.out"
  File finalReport  = "~{outputPrefix}_report.tsv"
  File consensusAssembly = "~{outputPrefix}_annot.fa"
}
}
