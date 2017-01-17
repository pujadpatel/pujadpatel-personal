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

vm= -60

vmvalues=[]
anvalues=[]
bnvalues=[]
amvalues=[]
bmvalues=[]
ahvalues=[]
bhvalues=[]

for i in range (1,112):
    an=alphaN(vm)
    bn=betaN(vm)
    am=alphaM(vm)
    bm=betaM(vm)
    ah=alphaH(vm)
    bh=betaH(vm)
    anvalues.append(an)
    bnvalues.append(bn)
    amvalues.append(am)
    bmvalues.append(bm)
    ahvalues.append(ah)
    bhvalues.append(bh)
    vmvalues.append(vm)
    if vm==-51.0:
        vm=vm+2
    elif vm==-36:
        vm=vm+2
    elif vm==-31:
        vm=vm+2
    else:
        vm=vm+1
 
# n0, m0, and h0
       
def ninfinity(vm1):
    return alphaN(vm1)/(alphaN(vm1)+betaN(vm1))
def minfinity(vm1):
    return alphaM(vm1)/(alphaM(vm1)+betaM(vm1))
def hinfinity(vm1):
    return alphaH(vm1)/(alphaH(vm1)+betaH(vm1))           
n0values=[]
m0values=[]
h0values=[]
vmvalues1=[]
vm1=-60

for i in range (1,112):
    n0=ninfinity(vm1)
    m0=minfinity(vm1)
    h0=hinfinity(vm1)
    n0values.append(n0)
    m0values.append(m0)
    h0values.append(h0)
    vmvalues1.append(vm1)
    if vm1==-51.0:
        vm1=vm1+2
    elif vm1==-36:
        vm1=vm1+2
    elif vm1==-31:
        vm1=vm1+2
    else:
        vm1=vm1+1

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
duration=[]
strength=[]

Is1=100
dur1=2
while Is1>4:
 while i<600:
    Ik=gkbar*(n**4)*(v-Ek)
    Ina=gnabar*(m**3)*h*(v-Ena)
    Il=glbar*(v-El)
    m=m+dt*(alphaM(v)*(1-m)-betaM(v)*m)
    n=n+dt*(alphaN(v)*(1-n)-betaN(v)*n)
    h=h+dt*(alphaH(v)*(1-h)-betaH(v)*h)
    if i<dur1:
        v=v+dt*(Is1-(Ina+Ik+Il))
    elif i>dur1:
        v=v+dt*(0-(Ina+Ik+Il))
    if v>20:
        duration.append(dur1-1)
        strength.append(Is1)
        print (Is1,dur1-1)
        if Is1==3:
            break
        else:
            Is1-=1
        i=1
        dur1=1
        v=-60
        n=ninfinity(v)
        m=minfinity(v)
        h=hinfinity(v)
        Ik=gkbar*(n**4)*(v-Ek)
        Ina=gnabar*(m**3)*h*(v-Ena)
        Il=glbar*(v-El)
    if i==599:
        i=1
        dur1=dur1+1
        v=-60
        n=ninfinity(v)
        m=minfinity(v)
        h=hinfinity(v)
        Ik=gkbar*(n**4)*(v-Ek)
        Ina=gnabar*(m**3)*h*(v-Ena)
        Il=glbar*(v-El)
    i+=1
    
#Plots

plt.figure(1)
plt.plot (duration, strength)
plt.show()