#!/usr/bin/python
import numpy as np
import matplotlib
#matplotlib.use('agg')
import matplotlib.pyplot as plt
import matplotlib.animation as animation


observable_file = "v-shape_fisst-15_15_scale8_seed1.observable.txt"
cv_file = "v-shape_fisst-15_15_scale8_seed1.colvar.txt"
#columns are time nsamples CV AverageForce(t) Force0 ObservableWeight0 Force1 ObservableWeight1 ...
observable_data = np.loadtxt(observable_file)
#cv data, first columns are time, x, y
cv_data = np.loadtxt(cv_file)

n_times, n_columns = observable_data.shape
n_forces = (n_columns - 4)//2

print("Num force points to evaluate observables, set to 41 in plumed file:",n_forces)

#force applied to x in file
x_t = cv_data[:,1]
y_t = cv_data[:,2]

ims = []
fig, ax=plt.subplots(figsize=(6,6))

for i in range(n_forces):
    force_i = observable_data[0,4+2*i]  
    force_label = "%.1f"%force_i
    observable_weights = observable_data[:,5+2*i]
    hist, bins_x, bins_y = np.histogram2d( x_t, y_t, weights = observable_weights, 
        range=[[-3,3],[-12,12]],bins=(100,100), density=True)
#note, histogram is transposed in x&y, so this presents the plot orientation as in the paper
    im = ax.imshow(hist,origin='lower', extent=(-12,12,-3,3), aspect=25./7)
    
    title_string = 'Force = %s'%force_label
    title = ax.text(0.5,1.05,title_string,
                    size=plt.rcParams["axes.titlesize"],
                    ha="center", transform=ax.transAxes, )
    ims.append([im,title])

ani = animation.ArtistAnimation(fig, ims, interval=50, blit=False,
                                repeat_delay=0)
ani.save("v-shape.gif")
