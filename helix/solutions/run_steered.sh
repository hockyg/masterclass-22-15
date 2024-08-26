#!/bin/bash
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
$lmp_plumed -log helix_fisst_example.log \
           -var plumed_file helix_smd.plumed.dat \
           -var outprefix helix_smd_cycles \
	   -var steps 10000000 \
           -var eps 7.5 \
           -in run_helix_plumed.lmp 
