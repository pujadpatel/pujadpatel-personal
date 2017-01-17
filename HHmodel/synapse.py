from math import *
import matplotlib.pyplot as plt


#Synapse
dt=0.01
v=-60
Isyn=0
Kp=5
Vt=2
Tmax=1
Ar=1.1
ad=0.19
Vpre=Isyn
Vampa=0
gbarampa=0.38
Iampa=gbarampa*(v-Vampa)

T=Tmax/(1+(e**(-(Vpre-Vt)/Kp)))
s0=Ar*Tmax/(Ar*Tmax+ad)
s=s0
dsvalues=[]
tout=[]
    
for i in range (1,1000):

    T=Tmax/(1+(e**(-(Vpre-Vt)/Kp)))
    ds=Ar*T*(1-s)-ad*s
    dsvalues.append(ds)
    
    tout.append(i*dt)
    print (ds)
    
#Plots

plt.figure(1)
plt.plot (tout, dsvalues)
plt.plot (tout, T)
plt.show()