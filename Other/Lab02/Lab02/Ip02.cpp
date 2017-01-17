//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 2
//  pujadpat@usc.edu


#include <iostream>

int main()
{
    //variables
    int favNumber;
    
    //user input
    std::cout << "Hello! What is your favorite number?" <<std::endl;
    std::cin >> favNumber;  //saves user input into favNumber
    
    //calculations
    if (favNumber % 2 == 0) //conditional uses modulo to determine remainders and divisibility
    {
        std::cout << "Your number is divisible by 2!" << std::endl;
    }
    if (favNumber % 3 == 0)
    {
        std::cout << "Your number is divisible by 3!" << std::endl;
    }
    if (favNumber % 5 == 0)
    {
        std::cout << "Your number is divisible by 5!" << std::endl;
    }
    if (favNumber % 7 == 0)
    {
        std::cout << "Your number is divisible by 7!" << std::endl;
    }
    if (favNumber % 11 == 0)
    {
        std::cout << "Your number is divisible by 11!" << std::endl;
    }
    
    // end nicely
    return 0;
}
