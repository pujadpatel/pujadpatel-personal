//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 23
//  pujadpat@usc.edu

#pragma once
#include <string>

class Candy
{
protected:
    std::string mName;
    int mAge;
    int mCalories;
    double mPrice;
public:
    Candy();
    Candy(std::string name, int age, int cal, double price);
    virtual void display();
};