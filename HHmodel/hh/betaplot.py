from math import *
import matplotlib.pyplot as plt
import numpy as np


vm=-80.0
i=0
vmvalues=[]
bnvalues=[]
def betaN(vm):
    return 0.125*e**(-(vm+60.0)/80.0)
for i in range (1,112):
    bn=betaN(vm)
    print (vm,bn)
    bnvalues.append(bn)
    vmvalues.append(vm)
    vm=vm+1

plt.plot (vmvalues,bnvalues)
plt.ylabel('vm')
plt.xlabel('bn')
plt.show() 
