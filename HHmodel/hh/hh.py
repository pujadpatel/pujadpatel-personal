from math import *
import matplotlib.pyplot as plt
import numpy as np


vm = -60
dt = 0.01
an = -0.1/(1-e)
bn = 0.125
n = 0

i=1

fo = open ('hh.txt', 'wb')

for i in range (1,100):
  n = round( n+dt*(an*(1-n)-bn*n), 4)
  dt = round(dt + 0.01,4)
  print (dt,n)
  plt.plot (n,dt)
  fo.write(str(dt))
  fo.write(str(", "))
  fo.write(str(n) + "\n")
plt.show()
fo.close()
