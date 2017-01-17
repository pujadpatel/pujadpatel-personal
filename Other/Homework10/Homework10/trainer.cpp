//  Puja Pattel
//  ITP 165, Fall 2015
//  Homework 10
//  pujadpat@usc.edu

#include "Animal.h"
#include <iostream>
#include <cstdlib>
#include <ctime>

//  Function: PrintStats
//  Purpose: prints out the stats of the animal
//  Parameters: none
//  Returns: none
void PrintStats(Animal& Animal)
{
    std::cout<<"********************************"<<std::endl;
    std::cout<<"Name: "<< Animal.getName() <<std::endl;
    std::cout<<"Health: " <<Animal.getHealth() << std::endl;
    std::cout<<"Power: "<< Animal.getPower() <<std::endl;
    std::cout<<"Armour: "<< Animal.getArmour() <<std::endl;
    std::cout<<"********************************"<<std::endl;
}

int main()
{
    //random number generator
    std::srand(std::time(0));
    //initialize animal pointer, variables
    Animal* aptr = nullptr;
    int userInput = 1;
    std::string fileName;
    std::string name;
    
    std::cout << "Welcome to ITP 165's Training Arena!" <<std::endl;
    
    while (userInput != 0) //loops through program
    {
        //options menu
        std::cout << std::endl << "\t Menu Options:";
        std::cout << std::endl<<"\t0. Save and Quit\n\t1. New Animal\n\t2. Load Animal\n\t3. Rename Animal\n\t4. Print Stats\n\t5. Heal Animal\n\t6. Train Animal: COMING SOON" << std::endl;
        std::cout << "What would you like to do? ";
        std::cin >> userInput;
        
        switch (userInput) //switch statement for options menu
        {
            case 0: //Save and quit
                std::cout << "Output file name? ";
                std::cin >> fileName;
                aptr->Save(fileName);
                std::cout << "Save complete! Time to quit, goodbye!" << std::endl;
                delete aptr;
                break;
            case 1: //New Animal
                std::cout << "Creating new animal..." <<std::endl;
                aptr = new Animal();
                std::cout << "Welcome your new animal:" <<std::endl;
                PrintStats(*aptr);
                break;
            case 2: //Load Animal
                std::cout << "Input file name? ";
                std::cin >> fileName;
                aptr = new Animal(fileName);
                std::cout << "Animal Loaded!" <<std::endl;
                PrintStats(*aptr);
                break;
            case 3: //Rename Animal
                std::cout << "New name: ";
                std::cin.ignore();
                std::getline(std::cin, name);
                aptr->setName(name); //resets name
                std::cout << "New name set." <<std::endl;
                PrintStats(*aptr);
                break;
            case 4: //Print Stats
                PrintStats(*aptr);
                break;
            case 5: //Heal Animal
            {
                int heal = std::rand()%10+1;
                std::cout << "Let's see what your healing roll is..." <<std::endl << "Healed by " << heal<<"!"<< std::endl;
                aptr->setHealth(aptr->getHealth()+heal);
                PrintStats(*aptr);
                break;
            }
            case 6: //Train Animal
                std::cout << "Feature Coming Soon!" <<std::endl;
                break;
            default: //tells user to input another number
                std::cout << "Please choose an option from the menu!" << std::endl;
        }
    }

    return 0;
}
