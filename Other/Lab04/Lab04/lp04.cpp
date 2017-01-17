//  Puja Patel
//  ITP 165, Fall 2015
//  Homework 2
//  pujadpat@usc.edu

#include <iostream>

int main()
{
    //variables
    int input;
    long long sum = 1;
    int counter = 1;
    
    std::cout << "Enter a number to use to compute a factorial." << std::endl << "Enter a negative number to quit: ";
    std::cin >> input;
    while (input >= 0)
    {
        while (counter <= input)
        {
            sum*=counter;
            counter++;
        }
        std::cout << input << "! = " << sum << std::endl << std::endl;
        
        std::cout <<"Enter a number to use to compute a factorial." << std::endl << "Enter a negative number to quit: ";
        std::cin >> input;
        sum = 1;
        counter = 1;
    }
    std::cout << std::endl << "Quitting!";
    return 0;
}
