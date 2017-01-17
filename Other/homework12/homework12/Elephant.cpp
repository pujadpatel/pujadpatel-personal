// Puja Patel
// ITP 165, Fall 2015
// Homework 12
// pujadpat@usc.edu

#include "Elephant.h"
#include <string>
#include <iostream>
#include <fstream>

Elephant::Elephant(std::string name)
{
    mhappiness = 100;
    menergy = 100;
    mhunger = 0;
    mage = 0;
    mName = name;
}

//setters
void Elephant::sethunger(int hunger)
{
    if (hunger <= 100)
    {
        mhunger = hunger;
    }
    if (mhunger <= 0)
    {
        mhunger = 0;
        mhappiness -= 10;
    }
}
void Elephant::sethappiness (int happiness)
{
    if (happiness <= 100)
    {
        mhappiness = happiness;
    }
    if (mhappiness <= 0)
    {
        mhappiness = 0;
        menergy -= 10;
    }
}
void Elephant::setenergy (int energy)
{
    if (energy <= 100)
    {
        menergy = energy;
    }
    if (menergy <= 0)
    {
        menergy = 0;
        mHealth -= 10;
    }
}
void Elephant::setage (int age)
{
    if (age >= 0)
    {
        mage = age;
    }
}

//getters
int Elephant::gethunger()
{
    return mhunger;
}
int Elephant::gethappiness()
{
    return mhappiness;
}

int Elephant::getenergy()
{
    return menergy;
}
int Elephant::getage()
{
    return mage;
}

//other functions

//  Function: Play
//  Purpose: plays with elephant; increases happiness by 10 and increases hunger by 20, increases xp by 30, decreases energy by 20
//  Parameters: none
//  Returns: none
void Elephant::Play()
{
    setXP(mXP+30);
    sethappiness(mhappiness+10);
    sethunger(mhunger+20);
    setenergy(menergy -20);
}
//  Function: feed
//  Purpose: feeds the elephant; decreases hunger by 10, increases xp by 10, increases happiness by 5, decreases energy by 10
//  Parameters: none
//  Returns: none
void Elephant::Feed()
{
    sethunger(mhunger - 10);
    setXP(mXP + 10);
    sethappiness(mhappiness + 5);
    setenergy(menergy - 10);
}
//  Function: GiveMedicine
//  Purpose: give elephant medicine; increases  health by 20, increases xp by 10, decreases happiness by 20, increases hunger by 10, decreases energy by 5
//  Parameters: none
//  Returns: none
void Elephant::GiveMedicine()
{
    setXP(mXP + 10);
    sethappiness(mhappiness - 20);
    setHealth(mHealth + 20);
    sethunger(mhunger + 10);
    setenergy(menergy - 5);
}
//  Function: Sleep
//  Purpose: increases energy by 20 and age by one, increases xp by 5, increases hunger by 10
//  Parameters: none
//  Returns: none
void Elephant::Sleep()
{
    setenergy(menergy + 20);
    setage(mage + 1);
    sethunger(mhunger + 10);
    setXP(mXP + 5);
}
//  Function: Load
//  Purpose: opens file and reads in variables to new Elephant
//  Parameters: file name
//  Returns: none
void Elephant::Load(std::string fileName)
{
    std::ifstream filein(fileName);
    if (filein.is_open())
    {
        int health, power, armour, level, experience, happiness, hunger, energy, age;
        std::string name;
        filein >> health;
        filein >> power;
        filein >> armour;
        filein >> level;
        filein >> experience;
        filein >> happiness;
        filein >> hunger;
        filein >> energy;
        filein >> age;
        filein.ignore();
        std::getline(filein, name);
        //sets variables to input
        mHealth = health;
        mPower = power;
        mArmour = armour;
        mLevel = level;
        mXP = experience;
        mhappiness = happiness;
        mhunger = hunger;
        menergy = energy;
        mage = age;
        mName = name;
    }
    filein.close();
}

//  Function: Save
//  Purpose: saves Elephant data to a file
//  Parameters: file name
//  Returns: none
void Elephant::Save(std::string fileName)
{
    std::ofstream fout(fileName);
    if (fout.is_open())
    {
        fout << mHealth << std::endl;
        fout << mPower << std::endl;
        fout << mArmour << std::endl;
        fout << mLevel << std::endl;
        fout << mXP << std::endl;
        fout << mhappiness << std::endl;
        fout << mhunger << std::endl;
        fout << menergy << std::endl;
        fout << mage << std::endl;
        fout << mName << std::endl;
    }
    fout.close();
}

//  Function: PrintStats
//  Purpose: prints stats to console
//  Parameters: none
//  Returns: none
void Elephant::PrintStats()
{
    std::cout << "***********************" << std::endl;
    std::cout << "Name: " << getName() << std::endl;
    std::cout << "Level: " << getLevel() << std::endl;
    std::cout << "Health: " << getHealth() << std::endl;
    std::cout << "Power: " << getPower() << std::endl;
    std::cout << "Armour: " << getArmour() << std::endl;
    std::cout << "XP to next level: " << 100 - (getXP()) << std::endl;
    std::cout << "Happiness: " << gethappiness() << std::endl;
    std::cout << "Hunger: " << gethunger() << std::endl;
    std::cout << "Energy: " << getenergy() << std::endl;
    std::cout << "Age: " << getage() << std::endl;
    std::cout << "***********************" << std::endl;
}

