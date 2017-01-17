//  Puja Pattel
//  ITP 165, Fall 2015
//  Homework 9
//  pujadpat@usc.edu

#include "Elephant.h"

Elephant::Elephant()
{
    mhappiness = 100;
    mhealth = 100;
    menergy = 100;
    mhunger = 0;
    mname = "No Name";
}

Elephant::Elephant(int happiness, int health, int energy, int hunger,int age, std::string name)
{
    sethappiness(happiness);
    sethealth(health);
    setenergy(energy);
    sethunger(hunger);
    setage(age);
    setname(name);
}

//setters
void Elephant::sethunger(int hunger)
{
    mhunger = hunger;
}
void Elephant::sethappiness (int happiness)
{
    mhappiness = happiness;
}
void Elephant::sethealth (int health)
{
    mhealth = health;
}
void Elephant::setenergy (int energy)
{
    menergy = energy;
}
void Elephant::setage (int age)
{
    mage = age;
}
void Elephant::setname (std::string name)
{
    mname = name;
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
int Elephant::gethealth()
{
    return mhealth;
}
int Elephant::getenergy()
{
    return menergy;
}
int Elephant::getage()
{
    return mage;
}
std::string Elephant::getname()
{
    return mname;
}

//other functions

//  Function: Play
//  Purpose: plays with elephant; increases happiness by 10 and decreases hunger by 5
//  Parameters: none
//  Returns: none
void Elephant::Play()
{
    mhappiness += 10;
    mhunger += 5;
}
//  Function: feed
//  Purpose: feeds the elephant; decreases hunger by 10
//  Parameters: none
//  Returns: none
void Elephant::Feed()
{
    mhunger -= 10;
}
//  Function: GiveMedicine
//  Purpose: give elephant medicine; increases happiness and health by 20
//  Parameters: none
//  Returns: none
void Elephant::GiveMedicine()
{
    mhappiness -= 20;
    mhealth += 20;
}
//  Function: Sleep
//  Purpose: increases energy by 20 and age by one
//  Parameters: none
//  Returns: none
void Elephant::Sleep()
{
    menergy += 20;
    mage += 1;
}














