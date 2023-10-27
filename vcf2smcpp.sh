#!/bin/sh
#=============================================================================#
# RUN SMC++ : write and launch a script for each sample and each chromosome
# STEP 1 : Create input file for SCM++ tools from a vcf file
#=============================================================================#

#===============================#
# Load Variable and Directories
#===============================#

# Population names (uses for the output directory)
POP=$1 ## Argument $1 : the name of output directory (e.g the name of the population)
# list of contig to run the loop on
Contigs="NC_051336.1" 
# get currant directory where run the script
dir="$PWD"
# (Optional) : PATH to a bed file to mask i) repeats ii) long homozygous streches (like centromeres)
Mask="/PATH_TO/Repeats.bed.gz"  
# Nb of randomly sample picking. If N="Nb tot of sample", all sample will be used at the end
N=5 
# create two list with different syntax but same individuals in it
Samples=(Sample1 Sample2 Sample3 Sample4 Sample5)
List="Sample1,Sample2,Sample3,Sample4,Sample5"

# Double loop : ona sample and then on chromosome lists:
for index in $(shuf --input-range=0-$(( ${#Samples[*]} - 1 )) -n ${N}) ## Select N samples among all samples to generate the smc format files
        do
        s=${Samples[$index]} ## Select one sample : use by SMC++ as "distinguished lineage"
        for chr in $Contigs ## Select one contig
                do
                mkdir ${dir}/${s}/ ## Create a directory for the sample
                mkdir ${dir}/${s}/${chr} ## Create a directory for the chromosome inside the sample directory
                cd ${dir}/${s}/${chr} 
        cat > ${s}_${chr}_vcf2smc.sh << EOF
#!/bin/sh
#SBATCH --clusters=mesopsl1
#SBATCH --account=lasojadart
#SBATCH --partition=def
#SBATCH --qos=mesopsl1_def_long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --job-name=${s}_${chr}_vcf2smc
#SBATCH --time=20:00:00
#SBATCH -o ${s}_${chr}_vcf2smc.o
#SBATCH -e ${s}_${chr}_vcf2smc.e
#SBATCH --mem-per-cpu=50G
#SBATCH -V

# IMPORT MODULE
module load gcc/9.2.0
module load python/3.7.3

# run vcf2smc
smc++ vcf2smc --cores XXX --mask ${Mask} -d ${s} ${s} ${chr}_GATK_filtered.vcf.gz ${s}_${chr}.smc.gz ${chr} $POP:$List

EOF
    sbatch ${s}_${chr}_vcf2smc.sh
    cd ${dir}
done
done