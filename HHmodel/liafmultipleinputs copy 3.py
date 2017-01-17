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
rate=0.05
Isynsum=0
num=100  #number of neurons
u=[[] for i in range (num)]
gsyn=[0]*num
Isyn=[0]*num
time=10001

for j in range (0,time):
    for i in range (0,num):
        if random.uniform(0,1) > rate:
            u[i].append(0)
        else:
            u[i].append(1)
            #plt.figure(1)
            #plt.plot([j],[i],'bo')
#plt.axis([-1,time+1,-1,num])
#plt.xlabel('Time')
#plt.ylabel('Neurons')

patternrangestart=1000
patternrangeend=1200
for j in range (patternrangestart,patternrangeend):
    for i in range (0,num):
        if u[i][j]==1:
            u[i][j]=2
            #plt.figure(3)
            #plt.plot([j],[i],'ro')

newu=[]
u2=[[] for i in range (num)]
k=0
lenbeforepattern=1000
frequency=1500

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
plt.axis([-1,len(u2[0]),-1,num])

#for i in range (1,10000):
#    for k in range (0,num):  
#      gsyn[k]=gsyn[k]+dt*(-(gsyn[k])+gbarsyn*u[k][i])
#      Isyn[k]=gsyn[k]*(V-Esyn)
#    for j in range (0,num):
#      Isynsum=Isynsum+Isyn[j]
#    V=V+(dt)*(((El-V)+Rm*Istim)/Tm-Isynsum)
#    Isynsum=0
#    if V > Vth:
#      V=vpeak  
#    dtvalues.append(dt*i)
#    Vvalues.append(V)
#    if V==vpeak:  
#      V = Vreset 
#
#plt.figure(2)
#plt.title('LIAF')
#plt.plot(dtvalues,Vvalues)   
  
           
plt.show()


