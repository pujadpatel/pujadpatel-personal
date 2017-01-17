from math import *
import matplotlib.pyplot as plt
import numpy as np


vm=-80.0
i=0
vmvalues=[]
bnvalues=[]
for i in range (1,112):
    bn=0.125*e**(-(vm+60.0)/80.0)
    print (vm,bn)
    bnvalues.append(bn)
    vmvalues.append(vm)
    vm=vm+1

plt.plot (vmvalues,bnvalues, 'ro')
plt.ylabel('vm')
plt.xlabel('bn')
plt.show() 
