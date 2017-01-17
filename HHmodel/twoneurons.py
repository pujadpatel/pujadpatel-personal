from math import *
import matplotlib.pyplot as plt
import numpy as np

#Betas and Alphas

def alphaN(vm):
    return (0.01*(10.0-(vm+60.0)))/((e**((10.0-(vm+60.0))/10.0))-1.0)
def betaN(vm):
    return 0.125*e**(-(vm+60.0)/80.0)
def alphaM(vm):
    return (0.1*(25.0-(vm+60.0)))/((e**(0.1*(25.0-(vm+60.0))))-1.0)
def betaM(vm):
    return  4.0*e**(-(60.0+vm)/18.0)
def alphaH(vm):
    return 0.07*e**(-(60.0+vm)/20.0)
def betaH(vm):
    return ((e**((30.0-(60.0+vm))/10.0)+1.0))**-1.0
 
# n0, m0, and h0
       
def ninfinity(vm1):
    return alphaN(vm1)/(alphaN(vm1)+betaN(vm1))
def minfinity(vm1):
    return alphaM(vm1)/(alphaM(vm1)+betaM(vm1))
def hinfinity(vm1):
    return alphaH(vm1)/(alphaH(vm1)+betaH(vm1))           

# HH

dt=0.01
gnabar=120
gkbar=36
glbar=0.3
Ena=52.4
Ek=-72.1
El=-49.2
v=-60

n=ninfinity(v)
m=minfinity(v)
h=hinfinity(v)
Ik=gkbar*(n**4)*(v-Ek)
Ina=gnabar*(m**3)*h*(v-Ena)
Il=glbar*(v-El)
 
# Interface

Is=90
Isyn=0
dur=24
vm1=-60
vm2=0
tout= []
vm1out=[]
vm2out=[]

#Synapse
Kp=5
Vt=2
Tmax=1
Ar=1.1
ad=0.19
Vpre=Isyn
Vampa=0
gbarampa=3
Iampa=gbarampa*(v-Vampa)

T=Tmax/(1+(e**(-(Vpre-Vt)/Kp)))
s0=Ar*Tmax/(Ar*Tmax+ad)
s=s0
dsvalues=[]
dtvalues=[]
for i in range (1,1000):
    ds=Ar*T*(1-s)-ad*s
    dsvalues.append(ds)
    dtvalues.append(i*dt)
    
for i in range (1,1000):
        #neuron 1
        Ik=gkbar*(n**4)*(vm1-Ek)
        Ina=gnabar*(m**3)*h*(vm1-Ena)
        Il=glbar*(vm1-El)
        m=m+dt*(alphaM(vm1)*(1-m)-betaM(vm1)*m)
        n=n+dt*(alphaN(vm1)*(1-n)-betaN(vm1)*n)
        h=h+dt*(alphaH(vm1)*(1-h)-betaH(vm1)*h)
        if i<dur:
            vm1=vm1+dt*(Is-(Ina+Ik+Il))
        elif i>dur:
            vm1=vm1+dt*(0-(Ina+Ik+Il))
        vm1out.append(vm1)
    
        #neuron 2
        Ik=gkbar*(n**4)*(vm2-Ek)
  	Ina=gnabar*(m**3)*h*(vm2-Ena)
        Il=glbar*(vm2-El)
        m=m+dt*(alphaM(vm2)*(1-m)-betaM(vm2)*m)
        n=n+dt*(alphaN(vm2)*(1-n)-betaN(vm2)*n)
        h=h+dt*(alphaH(vm2)*(1-h)-betaH(vm2)*h)
        if i<dur:
            vm2=vm2+dt*(Isyn-(Ina+Ik+Il))
        elif i>dur:
            vm2=vm2+dt*(0-(Ina+Ik+Il))
        vm2out.append(vm2)
        
        tout.append(i*dt)
        
#Plot   
    
plt.figure(1)
plt.plot (tout, vm1out)
plt.plot (tout, vm2out)
plt.plot (dtvalues, dsvalues)
plt.show()