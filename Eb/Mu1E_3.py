
import time
start_time =  time.time()
import numpy as np
from scipy.special import erfc
import sys
sys.path.append('/home/hcleroy/PostDoc/aging_condensates/Simulation/Parallel_Simulation')
sys.path.append('/home/hcleroy/Parallel_gillespie')
output_filename = sys.argv[1]

media =""

import Parallel_Run
from Cluster import Cluster
from ISF import ISF
from MSD import MSD
from Energy import NRG
from PCF import PCF
from PCF import PCF_L
from Time import Time

# gillespie parameter
Nlinker = 100
ell_tot = 1*10**5
kdiff = 0.001
Energy = 1
mu = Nlinker/ell_tot
Eb = np.array([-1,-2,-3,-4,-4.33,-4.66,-5,-5.5,-6,-7,-8,-9])
Eb = -Eb*np.log(mu)/np.log(10)



Nprocess = 12
seeds = set()
while len(seeds) < Nprocess:
    seeds.add(np.random.randint(1000000))
seeds = list(seeds)


args = [[ell_tot,Eb[_],kdiff,seeds[_],Nlinker,3] for _ in range(Nprocess)]

# argument of the different classes
avR = lambda L,N : 2*(np.exp(-1.5/(L/N)) * np.sqrt(L/N*6/np.pi)*(3+2*L/N) - 9*erfc(np.sqrt(3/2/(L/N))))/(9*L/N) #average distance between equilibrated nodes
Lcharact = lambda L,N : (np.sqrt(2*L/N/3))
cluster_arg = tuple([Lcharact(ell_tot,Nlinker)]) # max distance
MSD_arg = () # no argument 
ISF_arg = (1/avR(ell_tot,Nlinker),10) # q_norm, q_num_sample
NRG_arg = ()
PCF_arg = (15,50) # max_distance,numb_bin
PCF_L_arg = (ell_tot,30) # max_distance,numb_bin
Time_arg = ()

measurement_args = {
    'Cluster': (Cluster, cluster_arg),
    'MSD': (MSD, MSD_arg),
    'ISF': (ISF, ISF_arg),
    'PCF':(PCF,PCF_arg),
    'PCF_L':(PCF_L,PCF_L_arg),
    'NRG':(NRG,NRG_arg)#,
    #'Time':(Time,Time_arg)
    # Add other measurements as needed
}

measurement_flags = {
    'NRG':True,
    'Cluster': False,
    'MSD': False,
    'ISF': True,
    'PCF':True,
    'PCF_L':False#,
    #'Time':True
    # Set each measurement to True/False as desired
}

# Simulation parameters
step_tot = 1*10**5
#check_steps = 10**2
initial_check_steps = 10**1
coarse_grained_step = 10**0
log_base=None

Parallel_Run.parallel_evolution(args,step_tot,initial_check_steps,coarse_grained_step,media+output_filename+'.hdf',
                                measurement_args,measurement_flags,log_base)


duration = time.time()-start_time
# Convert seconds to days, hours, minutes, and seconds
days = int(duration // (24 * 3600))
duration = duration % (24 * 3600)
hours = int(duration // 3600)
duration %= 3600
minutes = int(duration // 60)
seconds = int(duration % 60)

# Print the formatted duration
print(f"Execution Time: {days} days, {hours} hours, {minutes} minutes, {seconds} seconds")