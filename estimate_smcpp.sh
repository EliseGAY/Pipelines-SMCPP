#!/bin/bash
#=================================#
# RUN SMC++ 
# STEP 2 : Get demographic model
#=================================#

#===============================#
# Load Variable and Directories
#===============================#


#$1 is the name of the folder you put the vcf2smc files. The estimate will be stored there as well
#Output : A CSV with four columns : name of the pop,time,Ne,path,iteration number (useless)

#Change MUTATIONRATE 
#Change GENERATIONS 
#
#Options :
#--cores : Change number of cores (related to the number of individuals + number of chromosomes)
#--knots : Change number of knots (~number of intervals)
#--timepoints : Restrain (or not) the period of time for the estimate of Ne

DIR=$PWD
mkdir $DIR/$1/estimate
cd $DIR/$1
cat > $1_estimate.sh << EOF
#!/bin/bash
#SBATCH --clusters=mesopsl1
#SBATCH --account=lasojadart
#SBATCH --partition=def
#SBATCH --qos=mesopsl1_def_long
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=${NAME}_smc
#SBATCH --time=20:00:00
#SBATCH -o ${NAME}_smc.o
#SBATCH -e ${NAME}_smc.e
#SBATCH --mem-per-cpu=50G
#SBATCH -V


# IMPORT MODULE PSL
module load gcc/9.2.0
module load python/3.7.3

#IMPORT MODULE GENOTOUL

module load system/Miniconda3-4.4.10
module load bioinfo/smcpp-v1.15.2

export OMP_NUM_THREADS=1

smc++ estimate --cores XX --timepoints 1 1000000 -o estimate/ MUTATIONRATE GN*/*/*.smc.gz --knots XXX
cd estimate
smc++ plot -c -g GENERATIONS smcpp_plot_$1.png model.final.json
smc++ plot -c -g GENERATIONS smcpp_plot_$1.png .model.iter*.json


EOF
    sbatch $1_estimate.sh
    cd $DIR
