//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 16
//  pujadpat@usc.edu

#include "Die.h"
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <sstream>

Die::Die()
{
    std::srand(std::time(0));
    mNumSides = 6;
    mResult = 0;
}

int Die::roll()
{
    mResult = std::rand() % mNumSides + 1;
    return mResult;
}

std::string Die::toString()
{
    std::string retVal = "";
    std::stringstream strStream;
    strStream << mResult;
    retVal = strStream.str();
    return retVal;
}
