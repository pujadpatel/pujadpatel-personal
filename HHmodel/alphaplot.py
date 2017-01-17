from math import *
import matplotlib.pyplot as plt
import numpy as np

def alphaN(vm):
    return (0.01*(vm+50.0))/1-(e**(-(vm+50.0)/10.0))
def betaN(vm1):
    return 0.125*e**(-(vm1+60.0)/80.0)
def alphaM(vm2):
    return (0.1*(vm2+35.0))/1-(e**(-(vm2+35.0)/10.0))
def betaM(vm3):
    return  4.0*e**(-(vm3+60.0)/18.0)
def alphaH(vm4):
    return 0.07*e**(-(vm4+60.0)/20.0)
def betaH(vm5):
    return 1/1+(e**(-(vm5+30.0)/10.0))
    
vm= -60
vm1=vm
vm2=vm
vm3=vm
vm4=vm
vm5=vm

vmvalues=[]
anvalues=[]
for i in range (1,112):
    an=alphaN(vm)
    anvalues.append(an)
    vmvalues.append(vm)
    if vm==-59.0:
        vm=vm+2
    else:
        vm=vm+1
      

vmvalues1=[]
bnvalues=[]
for i in range (1,112):
    bn=betaN(vm1)
    bnvalues.append(bn)
    vmvalues1.append(vm1)
    vm1=vm1+1
    
vmvalues2=[]
amvalues=[]
for i in range (1,112):
    am=alphaM(vm2)
    amvalues.append(am)
    vmvalues2.append(vm2)
    if vm2==-36.0:
        vm2=vm2+2
    else:
        vm2=vm2+1

vmvalues3=[]
bmvalues=[]
for i in range (1,112):
    bm=betaM(vm3)
    bmvalues.append(bm)
    vmvalues3.append(vm3)
    vm3=vm3+1
    
vmvalues4=[]
ahvalues=[]
for i in range (1,112):
    ah=alphaH(vm4)
    ahvalues.append(ah)
    vmvalues4.append(vm4)
    vm4=vm4+1
 
vmvalues5=[]
bhvalues=[]
for i in range (1,112):
    bh=betaH(vm5)
    bhvalues.append(bh)
    vmvalues5.append(vm5)
    if vm5==-31.0:
        vm5=vm5+2
    else:
        vm5=vm5+1   

plt.figure(1)   
plt.subplot(311)    
plt.plot (vmvalues, anvalues)
plt.plot (vmvalues1, bnvalues)
plt.title('n')   

plt.subplot(312)
plt.plot (vmvalues2, amvalues)
plt.plot (vmvalues3, bmvalues)
plt.title('m')

plt.subplot(313)
plt.plot (vmvalues4, ahvalues)
plt.plot (vmvalues5, bhvalues)
plt.title('h')
plt.show()



