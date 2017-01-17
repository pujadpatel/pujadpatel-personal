//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 16
//  pujadpat@usc.edu

#include "Die.h"
#include <iostream>

int main()
{
    Die d1, d2;
    int response, total;
    
    std::cout << "How many times would you like to roll? ";
    std::cin >> response;
    
    for (int i = 0; i < response; i++)
    {
        total = d1.roll() + d2.roll();
        std::cout << "You rolled a " << d1.toString() << " and a " << d2.toString() << " for a total of "
        << total << "!" <<std::endl;
    }
    return 0;
}
