//Puja Patel
//ITP 165, Fall 2015
//Homework 11
//pujadpat@usc.edu

#include <iostream>
#include "Animal.h"
#include <cstdlib>
#include <ctime>
#include <vector>

//  Function: RandOpponent
//  Purpose: creates a pointer to a dynamically allocated Animal object
//  Parameters: none
//  Returns: the pointer to this Animal object
Animal* RandOpponent ()
{
    Animal* aptr = nullptr;
    int health = 50;
    int level = std::rand()%5+1;
    int power = (std::rand()%20+0)+20;
    int armour = (std::rand()%20+0)+20;
    int xp = 0;
    std::string name = "Opponent";
    aptr = new Animal(name, health, power, armour, level, xp);
    return aptr;
}

int main()
{
    std::srand(std::time(0)); //seeds random number generator
    //initialize variables
    Animal* userPtr = nullptr;
    std::vector<Animal*> opponentPtr; //creates vector of animal pointers
    std::string name;
    int userInput = 1;
    int heal;
    int randNumOpp;
    std::string input;
    //Starts Program
    std::cout << "Welcome to the Training Arena!" <<std::endl;
    std::cout << "Animal Name? ";
    std::getline(std::cin, name);
    userPtr= new Animal(name); //creates new user Animal
    
    while (userInput != 0) //loops through program
    {
        //options menu
        std::cout << "\tMenu Options:" <<std::endl;
        std::cout <<"0. Quit\n1. Print Stats\n2. Heal Animal\n3. Train Animal" << std::endl;
        std::cout <<"What would you like to do? ";
        std::cin >> userInput;
        std::cout << std::endl;
        
        switch (userInput) //switch statement for options menu
        {
            case 0: //Quit
                std::cout << "Quitting...\nThanks for playing!";
                delete userPtr;
                for (int i = 0; i <opponentPtr.size();i++)
                {
                    delete opponentPtr[i];
                }
                return 0;
                break;
            case 1: //Print Stats
                userPtr->PrintStats();
                break;
            case 2: //Heal Animal
                heal = (std::rand()%40+0)+10; //randomly generates health
                if ((userPtr->getHealth())+heal>=100) //sets heatlh to 100, if heal amount greater than that allowed by setter
                {
                    userPtr->setHealth(100);
                }
                else
                {
                    userPtr->setHealth((userPtr->getHealth())+heal);
                }
                std::cout << "Healed by " << heal <<"!" <<std::endl;
                break;
            case 3: //Train Animal
            {
                if (userPtr->isAwake() == false) //animal must be awake to fight
                {
                    std::cout << "You need to heal your animal before it can train." <<std::endl;
                    break;
                }
                randNumOpp = std::rand()%3+1; //generates random number of opponents
                std::cout << "Let's get ready to train your animal!" << std::endl;
                if (randNumOpp > 1) //announces number of opponents
                {
                    std::cout << randNumOpp << " opponents generated!" <<std::endl;
                }
                else
                {
                    std::cout << randNumOpp << " opponent generated!" <<std::endl;
                }
                for (int i = 0; i < randNumOpp; i++) //adds opponents to vector
                {
                    Animal* next = RandOpponent();
                    opponentPtr.push_back(next);
                }
                int i = 1;
                while (userPtr->isAwake() == true && i<=randNumOpp)
                {
                    //announce stats
                    std::cout << "Ready for Round " << i << "? ";
                    std::cin >> input;
                    if (input.length() >= 1) //fight begins with any user input via console
                    {
                        std::cout << std::endl << "******* Round " << i << " ******" <<std::endl;
                        //std::cout << "**********************" <<std::endl;
                        opponentPtr[i-1]->PrintStats();
                        //std::cout << "**********************" <<std::endl;
                        std::cout <<"       VERSUS       " <<std::endl;
                        userPtr->PrintStats();
                        //std::cout << "**********************" <<std::endl <<std::endl;
                        
                        userPtr->FightOpponent(opponentPtr[i-1]); //fight
                        i++;
                    }
                }
                //clean up opponent vector
                for (int i =0; i<randNumOpp; i++)
                {
                    delete opponentPtr[i];
                }
                opponentPtr.clear();
                break;
            }
            default: //tells user to input another number
                std::cout << "Please choose an option from the menu!" << std::endl;
        }
    }
    
    return 0;
}
