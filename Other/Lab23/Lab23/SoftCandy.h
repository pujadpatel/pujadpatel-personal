//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 23
//  pujadpat@usc.edu

#pragma once
#include "Candy.h"

class SoftCandy : public Candy
{
protected:
    int mSoftness;
public:
    SoftCandy();
    SoftCandy(std::string name, int age, int cal, double price, int soft);
    void display();
};