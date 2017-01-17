//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 16
//  pujadpat@usc.edu

#pragma once
#include <string>

class Die
{    
private:
    int mResult;
    int mNumSides;
    
public:
    //default constructor
    Die();
    //returns a single die roll
    int roll();
    //converts die roll to string
    std::string toString();
};
