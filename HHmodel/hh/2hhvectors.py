from math import *
import matplotlib.pyplot as plt
from numpy import *

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
v2=-60
n=ninfinity(v)
m=minfinity(v)
h=hinfinity(v)
Ik=gkbar*(n**4)*(v-Ek)
Ina=gnabar*(m**3)*h*(v-Ena)
Il=glbar*(v-El)

Is=70
dur=100

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
    
n1= array([Ik, Ina, Il, m, n, h, v])
n2= array([Ik, Ina, Il, m, n, h, v])
neuron=array([n1,n2])
for i in range (1,1000):
  for row in neuron:
    row[0]=gkbar*(row[4]**4)*(row[6]-Ek)
    row[1]=gnabar*(row[3]**3)*row[5]*(row[6]-Ena)
    row[2]=glbar*(row[6]-El)
    T=Tmax/(1+(e**(-(v-Vt)/Kp)))

    row[3]=row[3]+dt*(alphaM(row[6])*(1-row[3])-betaM(row[6])*row[3])
    row[4]=row[4]+dt*(alphaN(row[6])*(1-row[4])-betaN(row[6])*row[4])
    row[5]=row[5]+dt*(alphaH(row[6])*(1-row[5])-betaH(row[6])*row[5])
    if i<dur:
        neuron[0][6]=neuron[0][6]+dt*(Is-(row[1]+row[0]+row[2]))
    elif i>dur:
        neuron[0][6]=neuron[0][6]+dt*(0-(row[1]+row[0]+row[2]))
    vout.append(neuron[0][6])
    
    Iampa=gbarampa*s*(v2-Vampa)
    Iampavalues.append(Iampa)
    s=s+dt*(Ar*T*(1-s)-ad*s)
    svalues.append(s)
    Tvalues.append(T)
    neuron[1][6]=neuron[1][6]+dt*(-(row[1]+row[0]+row[2]+Iampa))

    vout2.append(neuron[1][6])
    
    tout.append(i*dt)
    
#Plots

plt.figure(1)
plt.plot (tout, vout)
plt.plot(tout,vout2)
#plt.plot (tout, Tvalues)
plt.show()

#plt.figure(2)
#plt.plot (tout, Tvalues)
#
#plt.figure(3)
#plt.plot (tout,vout2)

#plt.figure(4)
#plt.plot (tout,Iampavalues)
#plt.show