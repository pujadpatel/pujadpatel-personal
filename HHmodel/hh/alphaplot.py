from math import *
import matplotlib.pyplot as plt
import numpy as np

vm=  -60.0
vm1=  vm
i=0
vmvalues=[]
vmvalues1=[]
anvalues=[]
bnvalues=[]

def alphaN(vm):
    return (-0.01*(vm+60.0))/(e**((vm+60.0)/10.0)-1)
for i in range (1,111):
    an=alphaN(vm)
    anvalues.append(an)
    vmvalues.append(vm)
    if vm==-51.0:
        vm=vm+2
    else:
        vm=vm+1
      
def betaN(vm1):
    return 0.125*e**((vm1+70.0)/-80.0)
for i in range (1,112):
    bn=betaN(vm1)
    print (vm1,bn)
    bnvalues.append(bn)
    vmvalues1.append(vm1)
    vm1=vm1+1
    
plt.plot (vmvalues, anvalues)
plt.plot (vmvalues1, bnvalues)
plt.title('n')
plt.show()    



