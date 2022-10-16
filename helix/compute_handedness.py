#!/usr/bin/python
import numpy as np
import mdtraj as md

def handedness(trj_file, left_struct='helix_left.xyz', right_struct='helix_right.xyz', top_file='helix.pdb', rmsd_cutoff=0.15):
    trj = md.load(trj_file,top=top_file)
    left_trj = md.load(left_struct,top=top_file)
    right_trj = md.load(right_struct,top=top_file)

    left_rmsd = md.rmsd(trj, left_trj)
    right_rmsd = md.rmsd(trj, right_trj)

    in_left_helix = np.where( (left_rmsd<right_rmsd)*(left_rmsd<rmsd_cutoff))[0]
    in_right_helix = np.where( (left_rmsd>right_rmsd)*(right_rmsd<rmsd_cutoff))[0]

    handedness = np.zeros(len(left_rmsd))
    handedness[in_left_helix] = left_rmsd[in_left_helix]-rmsd_cutoff
    handedness[in_right_helix] = rmsd_cutoff-right_rmsd[in_right_helix]

    return handedness

print("Input pdb handedness: ",handedness('helix.pdb'))

