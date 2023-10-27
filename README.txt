#===========================================#
# oct 2023
# Romuald Laso-Jadart - MNHN - EPHE
# Elise GAY - MNHN - EPHE
# Run SMC++
# please inform the authors before sharing
#===========================================#

# Aim : 
#------#
Run SMC++ on VCF files

# Input :
#----------#
gVCF file with all positions
BED file of repeat and/or homozygous streches

# Methods :
#----------#
This pipeline here is made to provide usable script to run SMC++ on the cluster
Adatped for PSL cluster with SLURM command

How to run the script on the cluster : 
sh vcf2smcpp.sh
sh estimate_smcpp.sh

note that the "sbatch script.sh" command is comprised inside both scripts ".sh" themself

Details of STEPS :
The pipeline is divided in 2 steps
- vcf2smcpp : 	transform the vcf in a smc++ format. Generate a file for each sample used as "ancestral" and for each chromosome.
				You may take subset of samples and/or chromosomes to run because of the multiple files generated.
				
- Estimate_smcpp.sh : 

# output :
#----------#
- Files : 	
		.smc.gz file : output file of vcf2smcpp.sh script
		A CSV with four columns : name of the pop,time,Ne,path,iteration number (useless)
