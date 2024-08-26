#!/bin/bash
#SBATCH --nodes=1
#SBATCH --job-name=test_helix_fisst
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4GB
#SBATCH --time=4:00:00

module purge
module load intel/19.1.2
module load cmake/3.18.4
module load openmpi/intel/4.0.5
module load python/intel/3.8.6

export PLUMED_PATH=/scratch/work/hockygroup/software/plumed2-icc-Sept2020
export PLUMED_KERNEL=$PLUMED_PATH/libplumedKernel.so
export PATH=$PLUMED_PATH/bin:/scratch/work/hockygroup/software/lammps/:$PATH
export C_INCLUDE_PATH=$PLUMED_PATH/include:$C_INCLUDE_PATH
export LD_LIBRARY_PATH=$PLUMED_PATH/lib:$LD_LIBRARY_PATH
export lmp_plumed=/scratch/work/hockygroup/software/lammps-github-quench/src/lmp_greene-plumed-cpu-14Dec2020
$lmp_plumed -log helix_sf_example.log \
           -var plumed_file helix_sf_f0_eps7.5_10000000.plumed.dat  \
           -var outprefix helix_sf_pull0 \
           -var steps 10000000  \
           -var eps 7.5 \
           -in run_helix_plumed.lmp 

exit

#note, pulling using RESTRAINT has opposite sign of forces to FISST. This is pulling out by F=4.5
$lmp_plumed -log helix_sf_example.log \
           -var plumed_file helix_sf_f-4.5_eps7.5_10000000.plumed.dat  \
           -var outprefix helix_sf_example \
           -var steps 10000000  \
           -var eps 7.5 \
           -in run_helix_plumed.lmp 

exit
$lmp_plumed -log helix_sf_example.log \
           -var plumed_file helix_sf_f-4.5_eps7.5_10000000.plumed.dat  \
           -var outprefix helix_sf_example \
           -var steps 10000000  \
           -var eps 7.5 \
           -in run_helix_plumed.lmp 

exit

$lmp_plumed -log helix_fisst_example.log \
           -var plumed_file helix_fisst_fmin-2.0_fmax8.0_eps7.5_50000000.plumed.dat \
           -var outprefix helix_fisst_example \
           -var steps 50000000  \
           -var eps 7.5 \
           -in run_helix_plumed.lmp 

exit

