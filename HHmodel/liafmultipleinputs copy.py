from math import *
import matplotlib.pyplot as plt
import numpy as np
import random


dt=.01
El=-65
Vreset=El
Rm=10
Tm=10
Vth=-50
VT=-55
Vmax=30
DQ=2.5
DE=5
Istim=0
Tsyn=10
V=Vreset
dtvalues=[]
Vvalues=[]
gmax=1.2
Esyn=10
gbarsyn=gmax*Tsyn
u=[]
t=[]
a=1
b=0
vpeak=30
rate=0.002
Isynsum=0
num=2  #number of neurons
u=[[] for i in range (num)]
gsyn=[0]*num
Isyn=[0]*num
for j in range (0,10001):
    for i in range (0,num):
        if random.uniform(0,1) > rate:
            u[i].append(0)
        else:
            u[i].append(1)

for i in range (1,10000):
    for k in range (0,num):  
      gsyn[k]=gsyn[k]+dt*(-(gsyn[k])+gbarsyn*u[k][i])
      Isyn[k]=gsyn[k]*(V-Esyn)
    for j in range (0,num):
      Isynsum=Isynsum+Isyn[j]
    V=V+(dt)*(((El-V)+Rm*Istim)/Tm-Isynsum)
    Isynsum=0
    if V > Vth:
      V=vpeak  
    dtvalues.append(dt*i)
    Vvalues.append(V)
    if V==vpeak:  
      V = Vreset 
    #print(dt*i,V)

plt.figure(1)
plt.title('LIAF')
plt.plot(dtvalues,Vvalues)   
  
plt.show()

