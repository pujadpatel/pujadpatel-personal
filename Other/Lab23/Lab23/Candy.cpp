//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 23
//  pujadpat@usc.edu

#include <iostream>
#include "candy.h"


Candy::Candy()
{
    mName = "";
    mAge = 0;
    mCalories = 0;
    mPrice = 0;
}

Candy::Candy(std::string name, int age, int cal, double price)
{
    mName = name;
    mAge = age;
    mCalories = cal;
    mPrice = price;
}

void Candy::display()
{
    std::cout << mName << " : " << mCalories << "\n\t" << mAge << " years " << "\n\t$" << mPrice <<std::endl;
}
