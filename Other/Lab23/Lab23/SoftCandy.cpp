//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 23
//  pujadpat@usc.edu

#include "SoftCandy.h"
#include <iostream>

SoftCandy::SoftCandy()
{
    mSoftness = 0;
}

SoftCandy::SoftCandy(std::string name, int age, int cal, double price, int soft) : Candy (name,age, cal,price), mSoftness(soft)
{
    
}

void SoftCandy::display()
{
    std::cout << mName << " : " << mCalories << "\n\t" << mAge << " years " << "\n\t$" << mPrice <<std::endl;
    std::cout << "level " << mSoftness << std::endl;
}