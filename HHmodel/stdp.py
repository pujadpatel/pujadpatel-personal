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
gsynvalues=[]
u=[]
t=[]
w=0.001
vpeak=30
rate=0.002
Wmax=1   #0.02
Wmin=0
mth=0
x=0
y=0
wy=0.002
alpha=1.05
events=[]
for j in range (0,10000):
        if random.uniform(0,1) > rate:
            u.append(0)
        else:
            u.append(1)

noise= [[random.gauss(0,25)] for i in range (0,10001)]

for i in range (1,10000): 
      x=(-x/Tm)+(mth/dt) 
      y=(-y/Tm)+(u[i]/dt)
      w=w+Wmax*x       
      w=w-Wmax*alpha*y
      if w>Wmax:
         w=Wmax
      #if w<Wmin:
      #  w=Wmin        
      Isyn=w*(V-Esyn)
      gsynvalues.append(w)
      V=V+(dt)*(((El-V)+Rm*Istim)/Tm-(Isyn))+noise[i][0]
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
    

#plt.figure(1)
#plt.title('LIAF')
#plt.plot(dtvalues,Vvalues)   
plt.figure(1)
plt.subplot(311)
plt.plot(dtvalues, events)
plt.subplot(312)
plt.plot(dtvalues,u[0:9999])
plt.subplot(313)
plt.plot(dtvalues,gsynvalues)  
#plt.figure(3)
#plt.plot(t,u)   

plt.show()