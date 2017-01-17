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
V=[Vreset,Vreset]
dtvalues=[]
V1values=[]
V2values=[]
gmax=1.2
gsyn=[0,0]
Isyn=[0,0]
Esyn=10
ginh=[5,5]
gext=[0.2,0.2]
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
rate=-0.002
rate2=0.002
u=[[],[]]
j=0
currentout1=0
currentout2=0
#
#for j in range (0,100001):
#    for k in range(0,2):
#      if k==0:
#        if random.uniform(0,1) > rate:
#            u[0].append(0)
#        else:
#            u[0].append(1)
#      if k==1:
#        if random.uniform(0,1) > rate2:
#            u[k].append(0)
#        else:
#            u[k].append(1)    

noise= [[random.gauss(0,100)] for i in range (0,100001)]
noise2 = [[random.gauss(0,100)] for i in range (0,100001)]
Istim1=150
Istim2=150
Esyn=-60
ebarsyn=100
for i in range (1,1000):
    gext[0]=gext[0]+dt*(-(gext[0])+ebarsyn*currentout1)
    ginh[0]=ginh[0]+dt*(-(ginh[0])+ebarsyn*currentout2)
    
    gext[1]=gext[1]+dt*(-(gext[1])+ebarsyn*currentout2)
    ginh[1]=ginh[1]+dt*(-(ginh[1])+ebarsyn*currentout1)
    
    V[0]=V[0]+(dt)*(((El-V[0])+Istim1)+gext[0]*(V[0]-Esyn)-ginh[0]*(V[0]-Esyn)+noise[i][0])
    V[1]=V[1]+(dt)*(((El-V[1])+Istim2)+gext[1]*(V[1]-Esyn)-ginh[1]*(V[1]-Esyn)+noise2[i][0])
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
    
    #print (dt*i,-ginh[0]*(V[0]-Esyn), currentoutn1, V[0])

    out1values.append(currentoutn1)
    out2values.append(currentoutn2)
    dtvalues.append(dt*i)
    V1values.append(V[0])
    V2values.append(V[1])
    if V[0]==vpeak:  
      V[0] = Vreset 
    if V[1]==vpeak:
      V[1] = Vreset  
t=0
out1values2=[]
out2values2=[]
while t <= 1000:
    num=random.randint(50,60)
    if num%2==0:
     out1values2+=out1values[t:t+num] 
     for i in range (0,num): 
      #if i<1:
      #  out2values2.append(1)
      #else:
        out2values2.append(0)
    
    else:
     out2values2+=out2values[t:t+num] 
     for i in range (0,num):
      #if i<1:        
      # out1values2.append(1)    
      #else:
       out1values2.append(0)   
    t+=num    

#plt.figure(1)
#plt.plot(dtvalues,V1values)
#plt.plot(dtvalues,V2values)   

plt.figure(2)
plt.subplot(211)
plt.plot(dtvalues, out1values2[0:999]) 
plt.subplot(212)
plt.plot(dtvalues, out2values2[0:999])

#plt.figure(2)
#plt.plot(dtvalues,gsynvalues1)  
#plt.plot(dtvalues,gsynvalues2)
 

plt.show()