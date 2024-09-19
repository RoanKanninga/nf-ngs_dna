#!/bin/bash

set -o pipefail
set -eu

rename "!{samples.combinedIdentifier}" "!{samples.externalSampleID}" "!{samples.combinedIdentifier}"*

perl -p -e "s|!{samples.combinedIdentifier}|!{samples.externalSampleID}|g" "!{samples.externalSampleID}.cnv.igv_session.xml" > "!{samples.projectResultsDir}/qc/!{samples.externalSampleID}.cnv.igv_session.xml"
grep "!{samples.combinedIdentifier}" "!{samples.projectResultsDir}/qc/stats.tsv" | perl -p -e "s|!{samples.combinedIdentifier}|!{samples.externalSampleID}|" >>  "!{samples.projectResultsDir}/qc/statsRenamed.tsv"

if [[ -e "!{samples.externalSampleID}.hard-filtered.vcf.gz" ]]
then
	rsync -Lv "!{samples.externalSampleID}.hard-filtered.vcf.gz"* "!{samples.projectResultsDir}/variants/"
fi

#
## gVCF
#
if [[ -e "!{samples.externalSampleID}.hard-filtered.gvcf.gz" ]]
then
	rename ".gvcf.gz" ".g.vcf.gz" "!{samples.externalSampleID}.hard-filtered.gvcf.gz"*
	rsync -Lv "!{samples.externalSampleID}.hard-filtered.g.vcf.gz"* "!{samples.projectResultsDir}/variants/gVCF/"
fi
#
## alignment
#
if [[ -e "!{samples.externalSampleID}.bam" ]]
then
	for i in "!{samples.externalSampleID}.bam"*
	do  
		mv $(readlink ${i}) "!{samples.projectResultsDir}/alignment/"
	done
	rename "!{samples.combinedIdentifier}" "!{samples.externalSampleID}" "!{samples.projectResultsDir}/alignment/"*
fi

#
## sv
#
if [[ -e "!{samples.externalSampleID}.sv.vcf.gz" ]]
then
	rsync -Lv "!{samples.externalSampleID}.sv.vcf.gz"* "!{samples.projectResultsDir}/variants/sv/"
fi

#
## cnv
#
if [[ -e "!{samples.externalSampleID}.cnv.vcf.gz" ]]
then
	rsync -Lv "!{samples.externalSampleID}"*cnv* "!{samples.projectResultsDir}/variants/cnv/"
fi 
if [[ -e "!{samples.externalSampleID}.target.counts.gz" ]]
then
	rsync -Lv "!{samples.externalSampleID}"*target.counts* "!{samples.projectResultsDir}/variants/cnv/"
fi
if [[ -e "!{samples.externalSampleID}.tn.tsv.gz" ]]
then
	rsync -Lv "!{samples.externalSampleID}"*.tn* "!{samples.projectResultsDir}/variants/cnv/"
fi
if [[ -e "!{samples.externalSampleID}.seg" ]]
then
	rsync -Lv "!{samples.externalSampleID}"*.seg* "!{samples.projectResultsDir}/variants/cnv/"
fi

#
## variants
#
if [[ -e "!{samples.externalSampleID}.roh.bed" ]]
then
	rsync -Lv "!{samples.externalSampleID}.roh.bed" "!{samples.projectResultsDir}/variants/"
fi
if [[ -e "!{samples.externalSampleID}.hard-filtered.baf.bw" ]]
then
	rsync -Lv "!{samples.externalSampleID}.hard-filtered.baf.bw" "!{samples.projectResultsDir}/variants/"
fi
if [[ -e "!{samples.externalSampleID}.ploidy.vcf.gz" ]]
then
	rsync -Lv "!{samples.externalSampleID}.ploidy.vcf.gz"* "!{samples.projectResultsDir}/variants/"
fi

#
## qc
#
if [[ -e "!{samples.externalSampleID}.html" ]]
then
	rsync -Lv "!{samples.externalSampleID}"*.{json,html} "!{samples.projectResultsDir}/qc/"
fi
if [[ -e "!{samples.externalSampleID}.improper.pairs.bw" ]]
then
	rsync -Lv "!{samples.externalSampleID}.improper.pairs.bw" "!{samples.projectResultsDir}/qc/"
fi
if [[ -e "sv" ]]
then
	rsync -Lv "sv" "!{samples.projectResultsDir}/qc/sv_!{samples.externalSampleID}"
fi

#
## additional_analysis
#
if [[ -e "!{samples.externalSampleID}.smn.tsv" ]]
then
	rsync -Lv "!{samples.externalSampleID}.smn.tsv"* "!{samples.projectResultsDir}/variants/additional_analysis/"
	rsync -Lv "!{samples.externalSampleID}.gba.tsv"* "!{samples.projectResultsDir}/variants/additional_analysis/"
	rsync -Lv "!{samples.externalSampleID}.repeats.vcf"* "!{samples.projectResultsDir}/variants/additional_analysis/"
fi
