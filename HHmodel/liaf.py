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
gsyn=0
Esyn=10
gbarsyn=gmax*Tsyn
gsynvalues=[]
u=[]
t=[]
a=1
b=0
vpeak=30
rate=0.002
for i in range (0,10001):
        if random.uniform(0,1) > rate:
            u.append(b)
        else:
            u.append(a)
        t.append(i)

for i in range (1,10000):
    gsyn=gsyn+dt*(-(gsyn)+gbarsyn*u[i])
    Isyn=gsyn*(V-Esyn)
    V=V+(dt)*(((El-V)+Rm*Istim)/Tm-Isyn)
    if V > Vth:
      V=vpeak  
    dtvalues.append(dt*i)
    Vvalues.append(V)
    gsynvalues.append(gsyn) 
    if V==vpeak:  
      V = Vreset 
    #print(dt*i,V)


    

plt.figure(1)
plt.title('LIAF')
plt.plot(dtvalues,Vvalues)   
plt.figure(2)
plt.plot(dtvalues,gsynvalues)  
#plt.figure(3)
#plt.plot(t,u)   

plt.show()
