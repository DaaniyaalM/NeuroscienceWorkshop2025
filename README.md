# NeuroscienceWorkshop2025
Script(s) I wrote to analyze simulation spiking data. 
I applied linearization to vectorize a matrix containing spiking data from a simulation of the neocortex.
I applied 3 different ways to group the data.
Way #1: Take the top 1% of weights, ascertain their indices and track how their particular index changes overtime. 
Way #2: Seperate the weights into 1 mV bins and track how their particular index changes overtime.
Way #3: Take all of the weights and track how they change overtime. 
 From this, we found that spiking data for log spike time dependent plasticity is quite mobile.
Surprising when considering the stability of the overall log normal shape of logSTDP's distribution curve. 
