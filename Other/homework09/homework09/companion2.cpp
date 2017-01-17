//  Puja Pattel
//  ITP 165, Fall 2015
//  Homework 9
//  pujadpat@usc.edu

#include <iostream>
#include "Elephant.h"
#include "FileIO.h"

//  Function: PrintStats
//  Purpose: prints out the stats of the elephant
//  Parameters: none
//  Returns: none
void PrintStats(Elephant& elephant)
{
    std::cout<<"********************************"<<std::endl;
    std::cout<<"Name: "<< elephant.getname() <<std::endl;
    std::cout<<"Health: " <<elephant.gethealth() << std::endl;
    std::cout<<"Happiness: "<< elephant.gethappiness() <<std::endl;
    std::cout<<"Hunger: "<< elephant.gethunger() <<std::endl;
    std::cout<<"Energy: "<< elephant.getenergy() <<std::endl;
    std::cout<<"Age: "<< elephant.getage() <<std::endl;
    std::cout<<"********************************"<<std::endl;
}

int main()
{
    //initialize variables
    int hunger = 0;
    int happiness = 100;
    int health = 100;
    int energy = 100;
    int age = 0;
    std::string name = "No Name";
    int userInput = 1;
    std::string fileName;
    
    //creates an object of Elephant
    Elephant elephant(happiness, health, energy, hunger, age, name);
    
    std::cout << "Welcome to the elephant sanctuary! Here is what we can do:" <<std::endl;
    
    while (userInput != 0) //loops through program
    {
        
        //options menu
        std::cout << std::endl<<"\t0. Save and Quit\n\t1. Load Elephant\n\t2. Feed\n\t3. Play\n\t4. Sleep\n\t5. Give Medicine\n\t6. Rename\n\t7. Print Stats" << std::endl;
        std::cout << std::endl<<"What would you like to do with your elephant? ";
        std::cin >> userInput;
        
        switch (userInput) //switch statement for options menu
        {
            case 0: //Save and quit
                std::cout << "Output file name? ";
                std::cin >> fileName;
                std::cout << "Preparing to save.." << std::endl;
                //update variables
                name = elephant.getname();
                health = elephant.gethealth();
                happiness = elephant.gethealth();
                hunger = elephant.gethunger();
                energy = elephant.getenergy();
                age = elephant.getage();
                //save to output file
                if (SaveAnimalData(fileName, name, health, happiness, hunger, energy, age) == true)
                {
                    std::cout << "Save successful." << std::endl << "Goodbye!";
                    return 0;
                }
                else
                {
                    std::cout << "Unable to save." << std::endl;
                }
                break;
            case 1: //Load elephant
                std::cout << "Input file name: ";
                std::cin >> fileName;
                std::cout << "Loading data..." <<std::endl;
                //loads data from file
                if (GetAnimalData(fileName, name, health, happiness, hunger, energy, age)==true)
                {
                    std::cout << "Load successful:" <<std::endl;
                    //sets variables to input
                    elephant.setname(name);
                    elephant.sethealth(health);
                    elephant.sethunger(hunger);
                    elephant.sethappiness(happiness);
                    elephant.setenergy(energy);
                    elephant.setage(age);
                    PrintStats(elephant);
                }
                else
                {
                    std::cout << "Load unsuccessful." <<std::endl;
                }
                break;
            case 2: //elephant gets fed
                std::cout << "Yummy! About to feed " << elephant.getname() <<"!" <<std::endl;
                elephant.Feed();
                std::cout <<"Fed your elephant!" <<std::endl;
                break;
            case 3: //Play
                std::cout << "Yay, it's so much fun to play with " << elephant.getname() <<"!" <<std::endl;
                elephant.Play();
                std::cout <<"Your elephant is much happier now!" <<std::endl;
                break;
            case 4: //sleep
                std::cout << "Time for bed, " << elephant.getname() <<"." <<std::endl;
                elephant.Sleep();
                std::cout <<"Your elephant slept soundly." <<std::endl;
                break;
            case 5: //give medicine
                std::cout << "Awww, " << elephant.getname() <<" doesn't feel well?" <<std::endl;
                elephant.GiveMedicine();
                std::cout <<"That medicine should help!" <<std::endl;
                break;
            case 6: //rename
                std::cout << "New name: ";
                std::cin.ignore();
                std::getline(std::cin, name);
                elephant.setname(name); //resets name
                std::cout << "New name set." <<std::endl;
                break;
            case 7: //print stats
                PrintStats(elephant);
                break;
            default: //tells user to input another number
                std::cout << "Please choose an option from the menu!" << std::endl;
        }
    }
    
    return 0;
}
