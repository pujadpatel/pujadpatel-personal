//  Puja Patel
//  ITP 165, Fall 2015
//  Lab Practical 5
//  pujadpat@usc.edu


#include <iostream>
#include <string>

int main()
{
    std::string name[4]=
    {
      "P", "U", "J", "A"
    };
    std:: string poem[4];
    
    for (int i=0; i < 4; i++)
    {
        std::cout << name[i] << " is for what? ";
        std::cin >> poem[i];
    }
    
    for (int i=0; i < 4; i++)
    {
        std::cout << name[i];
    }
    std::cout << std::endl;
    for (int i=0; i < 4; i++)
    {
        std::cout << name[i] << " is for " << poem[i]<< std::endl;
    }
    
    return 0;
}
