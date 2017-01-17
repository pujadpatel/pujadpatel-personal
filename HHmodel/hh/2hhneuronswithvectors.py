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
v=[-60,-60]
n=[ninfinity(v[0]), ninfinity(v[1])]
m=[minfinity(v[0]), minfinity(v[1])]
h=[hinfinity(v[0]), hinfinity(v[1])]
Ik=[gkbar*(n[0]**4)*(v[0]-Ek),gkbar*(n[1]**4)*(v[1]-Ek)]
Ina=[gnabar*(m[0]**3)*h[0]*(v[0]-Ena),gnabar*(m[1]**3)*h[1]*(v[1]-Ena)]
Il=[glbar*(v[0]-El),glbar*(v[1]-El)]
 
Is=70
dur=100

vout = []
vout2 = []
tout= []

#Synapse
Isyn=0
Kp=5
Vt=2
Tmax=1
Ar=1.1
ad=0.19
Vpre=v
Vampa=0
#-70
gbarampa=.38
#3
Iampa=gbarampa*(v[1]-Vampa)
T=Tmax/(1+(e**(-(v[0]-Vt)/Kp)))

s0=Ar*T/(Ar*T+ad)
s=s0
Tvalues=[]
    
for i in range (1,1000):
  for j in range(0,2):
    Ik[j]=gkbar*(n[j]**4)*(v[j]-Ek)
    Ina[j]=gnabar*(m[j]**3)*h[j]*(v[j]-Ena)
    Il[j]=glbar*(v[j]-El)
    T=Tmax/(1+(e**(-(v[0]-Vt)/Kp)))
    m[j]=m[j]+dt*(alphaM(v[j])*(1-m[j])-betaM(v[j])*m[j])
    n[j]=n[j]+dt*(alphaN(v[j])*(1-n[j])-betaN(v[j])*n[j])
    h[j]=h[j]+dt*(alphaH(v[j])*(1-h[j])-betaH(v[j])*h[j])
    if j==0:  
     if i<dur:
        v[0]=v[0]+dt*(Is-(Ina[0]+Ik[0]+Il[0]))
     elif i>dur:
        v[0]=v[0]+dt*(0-(Ina[0]+Ik[0]+Il[0]))
     vout.append(v[0])
    Iampa=gbarampa*s*(v[1]-Vampa)
    s=s+dt*(Ar*T*(1-s)-ad*s)
    if j==1:
     Tvalues.append(T)
     v[1]=v[1]+dt*(-(Ina[1]+Ik[1]+Il[1]+Iampa))
     vout2.append(v[1])
  tout.append(i*dt)
#Plots

plt.figure(1)
plt.plot (tout, vout)
plt.plot(tout,vout2)
plt.plot (tout, Tvalues)
plt.show()
