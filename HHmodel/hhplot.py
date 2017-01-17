from math import *
from numpy import *
import matplotlib.pyplot as plt


vm = -60
dt = 0.01
an = -0.1/(1-e)
bn = 0.125
n = 0
nvalues= zeros((100))
dtvalues=zeros((100))
def hh(dt):
    return n+dt*(an*(1-n)-bn*n)

for i in range (1,100):
  n = n+dt*(an*(1-n)-bn*n)
  nvalues[i]=n
  dtvalues[i]=i*0.01
  print (dt,n)

print (dtvalues)
print (nvalues)

  
plt.plot (dtvalues,nvalues)
plt.ylabel('n')
plt.xlabel('dt')
plt.show()
