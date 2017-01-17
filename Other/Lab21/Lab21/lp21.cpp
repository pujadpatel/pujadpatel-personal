//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 21
//  pujadpat@usc.edu

#include <iostream>
#include <vector>
#include "StrLib.h"

int main()
{
    std::string list;
    std::vector<std::string> stringList;
    double lengthSum = 0;
    double avgLength;
    
    std::cout << "Please enter a line of words separated by commas: ";
    std::getline(std::cin, list);
    stringList = strSplit(list, ',');
    
    for (int i =0; i < stringList.size(); i++)
    {
        lengthSum += stringList[i].length();
    }
    
    avgLength = lengthSum/stringList.size();
    std::cout << "The average world length was " << avgLength;
    
    return 0;
}
