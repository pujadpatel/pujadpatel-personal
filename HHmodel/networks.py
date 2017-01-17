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
Istim=0
Tsyn=10
V=[Vreset,Vreset]
dtvalues=[]
V1values=[]
V2values=[]
gmax=1.2
gsyn=[0,0]
Isyn=[0,0]
Esyn=10
ginh=.1
gext=.01
gbarsyn=gmax*Tsyn
out1=0
out2=0
out1values=[]
out2values=[]
currentoutn1=0
currentoutn2=0
u=[]
t=[]
vpeak=30
rate=0.02
rate2=0.02
u=[[],[]]
for j in range (0,100001):
    for i in range (0,2):
        if i==0:
          if random.uniform(0,1) > rate:
            u[i].append(0)
          else:
            u[i].append(1)
        if i==1:
          if random.uniform(0,1) > rate2:
            u[i].append(0)
          else:
            u[i].append(1)            

noise= [[random.gauss(0,.05)] for i in range (0,100001)]
noise2 = [[random.gauss(0,.05)] for i in range (0,100001)]


for i in range (1,10000):
    for k in range (0,2):
      if k==0:
              gsyn[k]=gsyn[k]+dt*(-(gsyn[k])+gbarsyn*u[k][i]+noise[i][0])
              Isyn[0]=gsyn[k]*(V[k]-Esyn)
      if k==1:
              gsyn[k]=gsyn[k]+dt*(-(gsyn[k])+gbarsyn*u[k][i]+noise2[i][0])
              Isyn[1]=gsyn[k]*(V[k]-Esyn)
      
    V[0]=V[0]+(dt)*(((El-V[0])+Rm*Istim)/Tm-(Isyn[0])+ginh*(V[0]+currentoutn2)+gext*(V[0]-currentoutn1))
    V[1]=V[1]+(dt)*(((El-V[1])+Rm*Istim)/Tm-(Isyn[1])+ginh*(V[1]+currentoutn1)+gext*(V[1]-currentoutn2))
    if V[0] > Vth:
      V[0]=vpeak
      currentoutn1=1
    else:
      currentoutn1=0   
    if V[1] > Vth:
      V[1]=vpeak
      currentoutn2=1
    else:
      currentoutn2=0
    out1values.append(currentoutn1)
    out2values.append(currentoutn2)
    dtvalues.append(dt*i)
    V1values.append(V[0])
    V2values.append(V[1])
    if V[0]==vpeak:  
      V[0] = Vreset 
    if V[1]==vpeak:
      V[1] = Vreset  

#plt.figure(1)
#plt.plot(dtvalues,V1values)
#plt.plot(dtvalues,V2values)   

plt.figure(2)
plt.subplot(211)
plt.plot(dtvalues, out1values) 
plt.subplot(212)
plt.plot(dtvalues, out2values)

#plt.figure(2)
#plt.plot(dtvalues,gsynvalues1)  
#plt.plot(dtvalues,gsynvalues2)
 

plt.show()

