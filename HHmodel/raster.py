import matplotlib.pyplot as plt
import numpy as np
import random
time=100
num=20  #number of neurons
u=[[] for i in range (num)]
rate = 0.01
for j in range (0,time):
    for i in range (0,num):
        if random.uniform(0,1) > rate:
            u[i].append(0)
        else:
            u[i].append(1)
            plt.figure(1)
            plt.plot([j],[i],'bo')

plt.axis([-1,time+1,-1,num])
plt.xlabel('Time')
plt.ylabel('Neurons')   

for j in range (20,30):
    for i in range (0,num):
        if u[i][j]==1:
            u[i][j]=2
            plt.figure(2)
            plt.plot([j],[i],'ro')


newu=[]
u2=[[] for i in range (num)]
k=0
patternlen=30
frequency=10

for i in range (0,num):
    while k<=time:
        u2[i]+=u[i][k:k+patternlen]+u[i][20:30]
        k+=frequency
    k=0

for j in range (0,len(u2[0])):
    for i in range (0,num):
        if u2[i][j]==1:
            plt.figure(3)
            plt.plot([j],[i],'bo')
        if u2[i][j]==2:
            plt.plot([j],[i],'ro')   
                    
plt.xlabel('Time')
plt.ylabel('Neurons') 
plt.axis([-1,len(u2[0]),-1,num])
           
plt.show()

