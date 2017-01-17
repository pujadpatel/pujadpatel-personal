from math import *
import matplotlib.pyplot as plt
import numpy as np
import random


dt=1
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
rate=0.05 #.07
Wmax=0.002
Wmin=0
mth=0
x=0
y=0
wy=0.002
alpha=1.05
events=[]
num=10  #number of neurons
gsynvalues=[[] for i in range (num)]
Isynsum=0
w=[0.002]*num
u=[[] for i in range (num)]
xdot=[0]*num
ydot=[0]*num
x=[0]*num
y=[0]*num
gsyn=[0]*num
Isyn=[0]*num
time=100001

for j in range (0,time):
    for i in range (0,num):
        if random.uniform(0,1) > rate*dt:
            u[i].append(0)
        else:
            u[i].append(1)
            #plt.figure(1)
            #plt.plot([j],[i],'bo')
#plt.axis([-1,time+1,-1,num])
#plt.xlabel('Time')
#plt.ylabel('Neurons')

patternrangestart=0
patternrangeend=50
for j in range (patternrangestart,patternrangeend):
    for i in range (0,num/2):
        if u[i][j]==1:
            u[i][j]=2
            #plt.figure(3)
            #plt.plot([j],[i],'ro')

noise= [[random.gauss(0,30)] for i in range (0,time)]

newu=[]
u2=[[] for i in range (num)]
k=0
lenbeforepattern=100
frequency=150
#frequency= random.randint(1000,3000)

for i in range (0,num):
    while k<=time:
        u2[i]+=u[i][k:k+lenbeforepattern]+u[i][patternrangestart:patternrangeend]
        k+=frequency
    k=0
    
for j in range (0,len(u2[0])):
    for i in range (0,num):
        if u2[i][j]==1:
            plt.figure(4)
            plt.plot([j],[i],'bo')
        if u2[i][j]==2:
            plt.plot([j],[i],'ro')   

plt.xlabel('Time')
plt.ylabel('Neurons') 
plt.axis([-1,2000,-1,num])
#plt.axis([-1,len(u2[0]),-1,num])


for i in range (1,time-1):
    for k in range (0,num):  
      gsyn[k]=gsyn[k]+dt*(-(gsyn[k])+gbarsyn*u[k][i])
      Isyn[k]=gsyn[k]*(V-Esyn)
      xdot[k]=(-x[k]/Tm)+(mth/dt) 
      ydot[k]=(-y[k]/Tm)+(u[k][i]/dt)
      x[k]=x[k]+xdot[k]*dt
      y[k]=y[k]+ydot[k]*dt 
      w[k]=w[k]+(.002*Wmax)*x[k]
      if w[k]>Wmax:
          w[k]=Wmax
      if w[k]<Wmin:
          w[k]=Wmin   
      w[k]=w[k]-(.002*Wmax)*alpha*y[k]          
      Isyn[k]=w[k]*(V-Esyn)
      gsynvalues[k].append(w[k])
    for j in range (0,num):
      Isynsum=Isynsum+Isyn[j]
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
      

plt.figure(3)
#plt.subplot(311)
plt.title('Events')
plt.plot(dtvalues,events) 
plt.axvline(x=0,color='green')
#plt.axvline(x=100,color='green')
#plt.axvline(x=250,color='green')
#plt.axvline(x=400,color='green')
#plt.axvline(x=550,color='green')
#plt.axvline(x=700,color='green')
#plt.axvline(x=850,color='green')
#plt.axvline(x=900,color='green')
#plt.axvline(x=1050,color='green')
#plt.axvline(x=1200,color='green')
#plt.axvline(x=1350,color='green')
#plt.axvline(x=1500,color='green')
#plt.axvline(x=1650,color='green')

#for i in range(1,666):
#    plt.axvline(x=(150*i-50), color='green')
    
#plt.subplot(312)
#plt.title('Poisson 1')
#plt.plot(dtvalues,u[0][0:9999])  
#plt.subplot(313)
#plt.title('Poisson 1 Weights')
#plt.plot(dtvalues, gsynvalues[0])  
#           
plt.show()
