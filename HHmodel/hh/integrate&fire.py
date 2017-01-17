from math import *
import matplotlib.pyplot as plt
import numpy as np


dt=0.01
El=-65
Vreset=El
Rm=10
Tm=10
Vth=-50
VT=-55
Vmax=30
DQ=2.5
DE=5
Istim=70

V=Vreset
dtvalues=[]
Vvalues=[]

def Flinear(V):
   return 0
def Fquad(V):
   return ((V-El)**2)/DQ    
def Fexp(V):
    return DE*(e**((V-VT)/DE))
    
for i in range (1,1000):
    V=V+dt*(((El-V)+Flinear(V)+Rm*Istim)/Tm)
    if V > Vth:
      V = Vreset
    dtvalues.append(dt*i)
    Vvalues.append(V)    
    print(dt*i,V)
    
dtvalues2=[]
Vvalues2=[]
for i in range (1,1000):
    V=V+dt*(((El-V)+Fquad(V)+Rm*Istim)/Tm)
    if V > Vmax:
      V = Vreset
    dtvalues2.append(dt*i)
    Vvalues2.append(V)    
    print(dt*i,V)
    
dtvalues3=[]
Vvalues3=[]
for i in range (1,1000):
    V=V+dt*(((El-V)+Fexp(V)+Rm*Istim)/Tm)
    if V > Vmax:
      V = Vreset
    dtvalues3.append(dt*i)
    Vvalues3.append(V)    
    print(dt*i,V)
    
plt.figure(1)
plt.title('LIAF')
plt.plot(dtvalues,Vvalues)        

plt.figure(2)
plt.title('QIAF')
plt.plot(dtvalues2,Vvalues2)

plt.figure(3)
plt.title('EIAF')
plt.plot(dtvalues3,Vvalues3)

plt.show()
