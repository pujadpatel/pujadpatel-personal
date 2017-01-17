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
Isyn=0
Esyn=10
gbarsyn=gmax*Tsyn
gsynvalues1=[]
gsynvalues2=[]
gsynvalues3=[]
gsynvalues4=[]
u=[]
t=[]
vpeak=30
rate=0.02
Wmax=0.05
Wmin=0
mth=0
wy=0.002
alpha=1.05
events=[]
Isynsum=0
num=20
w=[0]*num
x=[0]*num
y=[0]*num
Isyn=[[] for i in range (num)]
gsynvalues=[[] for i in range (num)]
u=[[] for i in range (num)]

for j in range (0,1000):
    for i in range (0,num):
        if random.uniform(0,1) > rate:
            u[i].append(0)
        else:
            u[i].append(1)

noise= [[random.gauss(0,50)] for i in range (0,10001)]

for i in range (1,1000):
  for j in range (0,num):   
      x[j]=(-x[j]/Tm)+(mth/dt) 
      y[j]=(-y[j]/Tm)+(u[j][i]/dt)
      w[j]=w[j]+Wmax*x[j]
      if w[j]>Wmax:
          w[j]=Wmax
      #if w[j]< Wmin:
      #    w[j]=Wmin    
      w[j]=w[j]-Wmax*alpha*y[j]     
      Isyn[j]=w[j]*(V-Esyn)
      gsynvalues[j].append(w[j])
  for k in range (0,num):
    Isynsum=Isynsum+Isyn[k]    
  V=V+(dt)*(((El-V)+Rm*Istim)/Tm-(Isynsum))+noise[i][0]
  Isynsum=0
  if V > Vth:
        V=vpeak  
  dtvalues.append(dt*i)
  Vvalues.append(V)
  if V==vpeak:  
      V = Vreset
      mth=1
      events.append(mth)
  else:
      mth=0
      events.append(mth)     
    #print(dt*i,V)


    
#print dtvalues
#print u[0]
plt.figure(1)
plt.subplot(311)
plt.title('Events')
plt.plot(dtvalues, events)
plt.subplot(312)
plt.title('Poisson 1')
plt.plot(dtvalues,u[0][0:999])  
plt.subplot(313)
plt.title('Poisson 1 Weights')
plt.plot(dtvalues, gsynvalues[0])
#plt.subplot(514)  
#plt.title('Poisson 2')
#plt.plot(dtvalues,u[1][0:999])
#plt.subplot(515)
#plt.title('Poisson 2 Weights')
#plt.plot(dtvalues, gsynvalues[1])


plt.show()