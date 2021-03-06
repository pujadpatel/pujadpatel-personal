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
v2=-60
n=ninfinity(v)
m=minfinity(v)
h=hinfinity(v)
Ik=gkbar*(n**4)*(v-Ek)
Ina=gnabar*(m**3)*h*(v-Ena)
Il=glbar*(v-El)
 
n2=ninfinity(v2)
m2=minfinity(v2)
h2=hinfinity(v2)
Ik2=gkbar*(n2**4)*(v2-Ek)
Ina2=gnabar*(m2**3)*h2*(v2-Ena)
Il2=glbar*(v2-El)

Is1=70
dur1=100

vout = []
tout= []
vout2 = []

#Synapse
Isyn=0
Kp=5
Vt=2
Tmax=1
Ar=1.1
ad=0.19
Vpre=v
Vampa=-70
gbarampa=3
Iampa=gbarampa*(v-Vampa)
T=Tmax/(1+(e**(-(v-Vt)/Kp)))

s0=Ar*T/(Ar*T+ad)
s=s0
svalues=[]
Tvalues=[]
Iampavalues=[]
    
for i in range (1,1000):
    Ik=gkbar*(n**4)*(v-Ek)
    Ina=gnabar*(m**3)*h*(v-Ena)
    Il=glbar*(v-El)
    T=Tmax/(1+(e**(-(v-Vt)/Kp)))

    m=m+dt*(alphaM(v)*(1-m)-betaM(v)*m)
    n=n+dt*(alphaN(v)*(1-n)-betaN(v)*n)
    h=h+dt*(alphaH(v)*(1-h)-betaH(v)*h)
    if i<dur1:
        v=v+dt*(Is1-(Ina+Ik+Il))
    elif i>dur1:
        v=v+dt*(0-(Ina+Ik+Il))
    vout.append(v)
    
    Ik2=gkbar*(n2**4)*(v2-Ek)
    Ina2=gnabar*(m2**3)*h2*(v2-Ena)
    Il2=glbar*(v2-El)
    Iampa=gbarampa*s*(v2-Vampa)
    Iampavalues.append(Iampa)
    m2=m2+dt*(alphaM(v2)*(1-m2)-betaM(v2)*m2)
    n2=n2+dt*(alphaN(v2)*(1-n2)-betaN(v2)*n2)
    h2=h2+dt*(alphaH(v2)*(1-h2)-betaH(v2)*h2)
    s=s+dt*(Ar*T*(1-s)-ad*s)
    svalues.append(s)
    Tvalues.append(T)
    v2=v2+dt*(-(Ina2+Ik2+Il2+Iampa))

    vout2.append(v2)
    
    tout.append(i*dt)
    
#Plots

plt.figure(1)
plt.plot (tout, vout)
plt.plot(tout,vout2)
plt.plot (tout, Tvalues)
plt.show()

#plt.figure(2)
#plt.plot (tout, Tvalues)
#
#plt.figure(3)
#plt.plot (tout,vout2)

plt.figure(4)
plt.plot (tout,Iampavalues)
plt.show