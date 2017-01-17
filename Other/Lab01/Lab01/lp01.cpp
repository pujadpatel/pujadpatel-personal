//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 1
//  pujadpat@usc.edu

#include <iostream>
#include <string>

int main()
{
    //variables
    int numbers;
    
    //user input
    std::cout << "Hello! Please give me a 2 digit whole number: ";
    std::cin >> numbers;
    
    //calculations
    //numbers = numbers * 20
    numbers *= 20;
    
    //output
    std::cout << "We have \"transformed\" your number into: " << numbers ;
    
    //end nicely
    return 0;
}
