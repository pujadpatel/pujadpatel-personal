from math import *
import matplotlib.pyplot as plt
import numpy as np

vm=-80.0
i=0
vmvalues=[]
anvalues=[]
for i in range (1,111):
    an=(0.01*(vm+50.0))/(1-e**(-(vm+50.0)/10.0))
    print(vm,an)
    anvalues.append(an)
    vmvalues.append(vm)
    if vm==-51.0:
        vm=vm+2
    else:
        vm=vm+1
plt.plot (vmvalues,anvalues, 'ro')
plt.ylabel('vm')
plt.xlabel('an')
plt.show()    



