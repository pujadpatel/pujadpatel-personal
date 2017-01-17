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
gsyn=[0,0]
Isyn=[0,0]
Esyn=10
gbarsyn=[gmax*Tsyn,.5*(gmax*Tsyn)]
gsynvalues1=[]
gsynvalues2=[]
u=[[],[]]
t=[]
a=1
b=0
vpeak=30
rate=0.002
for j in range (0,10001):
    for i in range (0,2):
        if random.uniform(0,1) > rate:
            u[0].append(0)
        else:
            u[1].append(1)

# Network 1
for i in range (1,10000):
  for k in range (0,2):   
    gsyn[k]=gsyn[k]+dt*(-(gsyn[k])+gbarsyn[k]*u[i])
    Isyn[k]=gsyn[k]*(V-Esyn)
    if k==0:
      gsynvalues1.append(gsyn[0])
    if k==1:
      gsynvalues2.append(gsyn[1])
  V=V+(dt)*(((El-V)+Rm*Istim)/Tm-(Isyn[0]+Isyn[1]))
  if V > Vth:
      V=vpeak  
  dtvalues.append(dt*i)
  Vvalues.append(V)
  if V==vpeak:  
      V = Vreset 

#Network 2
gsyn2=[0,0]
Isyn2=[]
V2=Vreset
V2values=[]
gsyn2values1=[]
gsyn2values2=[]

for i in range (1,10000): 
  for k in range (0,2):
    gsyn2[k]=gsyn2[k]+dt*(-(gsyn2[k])+gbarsyn[k]*u[i])
    if k==0:
      gsyn2values1.append(gsyn2[0])
    if k==1:
      gsyn2values2.append(gsyn2[1])
  Isyn2=(gsyn2[0]+gsyn2[1])*(V2-Esyn)
  V2=V2+(dt)*(((El-V2)+Rm*Istim)/Tm-(Isyn2))
  if V2 > Vth:
      V2=vpeak  
  V2values.append(V2)
  if V2==vpeak:  
      V2 = Vreset    

plt.figure(1)
plt.title('LIAF')
plt.plot(dtvalues,Vvalues)
plt.plot(dtvalues,V2values)   
plt.figure(2)
plt.plot(dtvalues,gsynvalues1)  
plt.plot(dtvalues,gsynvalues2)
#plt.figure(3)
#plt.plot(dtvalues,V2values) 

plt.show()

