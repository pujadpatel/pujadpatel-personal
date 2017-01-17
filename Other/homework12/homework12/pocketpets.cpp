// Puja Patel
// ITP 165, Fall 2015
// Homework 12
// pujadpat@usc.edu

#include <iostream>
#include "Elephant.h"
#include <vector>

//  function: RandOpponents
//  Purpose: generates an Animal pointer to random opponents
//  Parameters: none
//  Returns: Animal pointer
Animal* RandOpponents()
{
    int randNumOpp;
    Animal* aptr = nullptr;
    randNumOpp = std::rand()%5+1;
    switch(randNumOpp) //cases for different opponents
    {
        case 1:
            aptr = new Animal("Stew the Turtle", 50, 25, 50, 1, 0);
            return aptr;
            break;
        case 2:
            aptr = new Animal("Carl the Capybara", 50, 50, 50, 2, 0);
            return aptr;
            break;
        case 3:
            aptr = new Animal("Harold the Hyena", 75, 60, 65, 3,0);
            return aptr;
            break;
        case 4:
            aptr = new Animal("Peter the Puma", 100, 75, 75, 4, 0);
            return aptr;
            break;
        case 5:
            aptr = new Animal("Earl the Elephant", 100, 75, 75, 5, 0);
            return aptr;
            break;
    }
    return aptr;
}

//  function: TrainAnimal
//  Purpose: menu for animal training
//  Parameters: Elephant pointer
//  Returns: none
void TrainAnimal (Elephant* eleptr)
{
    int userInput = -1;
    while (userInput != 0) //loops through program
    {
        //options menu
        std::cout << std::endl<<"\tTRAINING\n~~~~~~~~~~~~~~~~~~~~~~~~~\n\t0. Return to Menu\n\t1. Feed Elephant\n\t2. Play with Elephant\n\t3. Give Medicine\n\t4. Put Elephant to Bed\n~~~~~~~~~~~~~~~~~~~~~~~~~" << std::endl;
        std::cout << std::endl<<"What would you like to do? ";
        std::cin >> userInput;
        
        switch (userInput) //switch statement for options menu
        {
            case 0: //return to menu
                std::cout << "Returning to previous menu..." <<std::endl;
                break;
            case 1: //elephant gets fed
                std::cout << "Yummy! Just fed " << eleptr->getName() <<"!" <<std::endl;
                eleptr->Feed();
                eleptr->PrintStats();
                break;
            case 2: //Play
                std::cout << "Yay, it's so much fun to play with " << eleptr->getName() <<"!" <<std::endl;
                eleptr->Play();
                eleptr->PrintStats();
                break;
            case 3: //give medicine
                std::cout <<"That medicine should help "<< eleptr->getName()<<"!" <<std::endl;
                eleptr->GiveMedicine();
                eleptr->PrintStats();
                break;
            case 4: //sleep
                std::cout << eleptr->getName() <<" has been put to bed." <<std::endl;
                eleptr->Sleep();
                eleptr->PrintStats();
                break;
            default: //tells user to input another number
                std::cout << "Please choose an option from the menu!" << std::endl;
        }
    }
}

//  function: BattleOpponents
//  Purpose: menu for battling
//  Parameters: Animal pointer & vector of animal pointers
//  Returns: none
void BattleOpponents(Animal* userPtr, std::vector<Animal*> opponentPtr)
{
    int userInput = -1;
    int numopps=0;
    std::string input;
    
    while (userInput != 0) //loops through program
    {
        //options menu
        std::cout << std::endl<<"\n\tBATTLE\n~~~~~~~~~~~~~~~~~~~~~~~~~\n\t0. Return to Menu\n\t1. Generate Opponents\n\t2. Battle Opponents\n\t3. Print Stats\n~~~~~~~~~~~~~~~~~~~~~~~~~" << std::endl;
        std::cout << std::endl<<"What would you like to do? ";
        std::cin >> userInput;
        
        switch (userInput) //switch statement for options menu
        {
            case 0: //return to menu
                std::cout << "Returning to previous menu..." <<std::endl;
                break;
            case 1: //generate new opponents case
                for (int i = 0; i <opponentPtr.size();i++)
                {
                    delete opponentPtr[i];
                }
                std::cout << "How many opponents would you like to generate (1-10)? ";
                std::cin >> numopps;
                std::cout << numopps << " opponents generated!" <<std::endl;
                for (int i = 0; i < numopps; i++) //adds opponents to vector
                {
                    Animal* next = RandOpponents();
                    opponentPtr.push_back(next);
                }
                break;
            case 2: //battle
            {
                if (opponentPtr.size() <= 0) //if no opponents
                {
                    std::cout << "Please generate opponents before battling" <<std::endl;
                    break;
                }
                int i = 1;
                while (i<=numopps) //loops through opponents for battles
                {
                    if (userPtr->isAwake() == false) //checks if user is awake
                    {
                        std::cout << "Your elephant is not awake! You must heal them before battling." <<std::endl;
                        break;
                    }
                    if (opponentPtr[i-1]->isAwake() == false) //checks if opponent is awake
                    {
                        std::cout << "Your opponent is not awake! Generate new opponents to continue." <<std::endl;
                        break;
                    }
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
                for (int i =0; i<numopps; i++)
                {
                    delete opponentPtr[i];
                }
                opponentPtr.clear();
                break;
            }
            case 3: //print stats
                userPtr->PrintStats();
                break;
            default: //tells user to input another number
                std::cout << "Please choose an option from the menu!" << std::endl;
        }
    }
}

int main()
{
    //initialize variables
    std::srand(time(0));
    Elephant* userPtr;
    int userInput;
    int option = -1;
    std::string filename, name, save;
    std::vector<Animal*> opponentPtr;
    
    //begin program
    std::cout<< "Welcome to the complete edition of 165's Animal Training!\n~~~~~~~~~~~~~~~~~~~~~~~~~\n1. Load Elephant?\n2. New Elephant?\n~~~~~~~~~~~~~~~~~~~~~~~~~" << std::endl;
    std::cout << "What would you like to do? ";
    std::cin >> userInput;
    if (userInput == 1) //loads elephant
    {
        std::cout << "What is the file name?";
        std::cin >>filename;
        userPtr = new Elephant(name);
        userPtr-> Load(filename);
    }
    if (userInput == 2) //creates new elephant
    {
        std::cout << "What is the Elephant's name? ";
        std::cin >> name;
        userPtr = new Elephant(name);
    }
    userPtr->PrintStats();
    
    while (option !=0)
    {
        //options menu
        std::cout << std::endl<<"\n~~~~~~~~~~~~~~~~~~~~~~~~~\n\t0. Quit Game\n\t1. Train Elephant\n\t2. Battle Opponent\n~~~~~~~~~~~~~~~~~~~~~~~~~" << std::endl;
        std::cout << std::endl<<"What would you like to do? ";
        std::cin >> userInput;
        switch (userInput)
        {
            case 0: //quit game
                std::cout << "Would you like to save your elephant (y/n)? ";
                std::cin >> save;
                if (save == "y" || save == "Y")
                {
                    std::cout << "File output name: ";
                    std::cin >> filename;
                    userPtr->Save(filename); //saves elephant
                    std::cout << "Elephant saved." <<std::endl;
                }
                delete userPtr; //cleans up memory
                for (int i = 0; i <opponentPtr.size();i++)
                {
                    delete opponentPtr[i];
                }
                std::cout << "Quitting!" <<std::endl;
                return 0;
                break;
            case 1: //train elephant
                TrainAnimal(userPtr);
                break;
            case 2: //battle
                BattleOpponents(userPtr, opponentPtr);
                break;
            default: //tells user to input another number
                std::cout << "Please choose an option from the menu!" << std::endl;
        }
    }
    
    return 0;
}
