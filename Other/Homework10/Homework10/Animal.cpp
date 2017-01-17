//  Puja Pattel
//  ITP 165, Fall 2015
//  Homework 10
//  pujadpat@usc.edu

#include "Animal.h"
#include <fstream>
#include <iostream>

//Default Constructor: will set private member variables to default values
Animal::Animal()
{
    mName = "Animal";
    mHealth = 70;
    mPower = 60;
    mArmour = 50;
}

//Non-Default Constructor: will set private member variables via parameters
Animal::Animal(std::string name, int health, int power, int armour)
{
    mName = name;
    mHealth = health;
    mPower = power;
    mArmour = armour;
}

//Non-Default Constructor: will set private member variables from data in file
//calls implemented Load(fileName) function
Animal::Animal(std::string fileName)
{
    Animal::Load(fileName);
}

//Getters
std::string Animal::getName()
{
    return mName;
}
int Animal::getHealth()
{
    return mHealth;
}
int Animal::getPower()
{
    return mPower;
}
int Animal::getArmour()
{
    return mArmour;
}
//Setters
void Animal::setName(std::string name)
{
    mName = name;
}
void Animal::setHealth(int health) //range between 0 and 100
{
    if (health >= 0 && health <= 100)
    {
        mHealth = health;
    }
}
void Animal::setPower(int power) //range between 0 and 100
{
    if (power >= 0 && power <= 100)
    {
        mPower = power;
    }
}
void Animal::setArmour(int armour) //range between 0 and 100
{
    if (armour >= 0 && armour <= 100)
    {
        mArmour = armour;
    }
}

//Other Functions
//Name: Load
//Purpose: Opens file to read in animal data to temporary variables, CLOSES the file, then sets animal data with temp variable values - sets animal data to default values if file open failed
//Parameters: string of file name to be opened
//Return: none
void Animal::Load(std::string fileName)
{
    std::ifstream instream(fileName);
    if (instream.is_open())
    {
        int thealth;
        int tpower;
        int tarmour;
        std::string tname;
        
        instream >> thealth;
        instream.ignore();
        instream >> tpower;
        instream.ignore();
        instream >> tarmour;
        instream.ignore();
        std::getline(instream, tname);
        instream.close();
        
        Animal::setHealth(thealth);
        Animal::setPower(tpower);
        Animal::setArmour(tarmour);
        Animal::setName(tname);
    }
    else
    {
        Animal::setHealth(70);
        Animal::setPower(60);
        Animal::setArmour(50);
        Animal::setName("Animal");
    }
}

//Name: Save
//Purpose: Opens a file to write CURRENT animal data to, then CLOSES the file, does nothing if file open failed
//Parameters: string of file name to be opened
//Return: none
void Animal::Save(std::string fileName)
{
    std::ofstream outstream(fileName);
    if (outstream.is_open())
    {
        outstream << mHealth << std::endl;
        outstream << mPower << std::endl;
        outstream << mArmour << std::endl;
        outstream << mName << std::endl;
        outstream.close();
    }
}
