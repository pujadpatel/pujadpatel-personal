from math import *
import matplotlib.pyplot as plt
import numpy as np

def alphaN(vm):
    return (0.01*(10-vm))/((e**((10-vm)/10.0))-1)
def betaN(vm1):
    return 0.125*e**(-vm1/80.0)
def alphaM(vm2):
    return (0.1*(25-vm2))/((e**(0.1*(25-vm2)))-1)
def betaM(vm3):
    return  4.0*e**(-vm3/18.0)
def alphaH(vm4):
    return 0.07*e**(-vm4/20.0)
def betaH(vm5):
    return ((e**((30-vm5)/10.0)+1))**-1
    
vm= -60
vm1=vm
vm2=vm
vm3=vm
vm4=vm
vm5=vm
vm6=vm
vm7=vm
vm8=vm

vmvalues=[]
anvalues=[]
for i in range (1,112):
    an=alphaN(vm)
    anvalues.append(an)
    vmvalues.append(vm)
    if vm==9.0:
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
    if vm2==24.0:
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
    if vm5==29.0:
        vm5=vm5+2
    else:
        vm5=vm5+1
        
def ninfinity(vm6):
    return alphaN(vm6)/(alphaN(vm6)+betaN(vm6))
def minfinity(vm7):
    return alphaM(vm7)/(alphaM(vm7)+betaM(vm7))
def hinfinity(vm8):
    return alphaH(vm8)/(alphaH(vm8)+betaH(vm8))

vmvalues6=[]
n0values=[]
for i in range (1,112):
    n0=ninfinity(vm6)
    n0values.append(n0)
    vmvalues6.append(vm6)
    vm6=vm6+1

vmvalues7=[]
m0values=[]
for i in range (1,112):
    m0=minfinity(vm7)
    m0values.append(m0)
    vmvalues7.append(vm7)
    vm7=vm7+1

vmvalues8=[]
h0values=[]
for i in range (1,112):
    h0=hinfinity(vm8)
    h0values.append(h0)
    vmvalues8.append(vm8)
    vm8=vm8+1

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

plt.figure(2)
plt.subplot(311)
plt.plot(vmvalues6,n0values)
plt.title('n0')

plt.subplot(312)
plt.plot(vmvalues7,m0values)
plt.title('m0')

plt.subplot(313)
plt.plot(vmvalues8,h0values)
plt.title('h0')
plt.show()

