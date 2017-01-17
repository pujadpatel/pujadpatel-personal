// Puja Patel
// ITP 165, Fall 2015
// Homework 12
// pujadpat@usc.edu

#include "Animal.h"
#include <iostream>
#include <cstdlib>
#include <ctime>

//Constructors
Animal::Animal()
{
    std::srand(time(0));
    setName("Animal Fighter");
    setHealth(100);
    setPower(50);
    setArmour(50);
    setLevel(1);
    setXP(0);
}
Animal::Animal(std::string name, int health, int power, int armour, int level, int xp)
{
    std::srand(time(0));
    setName(name);
    setHealth(health);
    setPower(power);
    setArmour(armour);
    setLevel(level);
    setXP(xp);
}
Animal::Animal(std::string name)
{
    std::srand(time(0));
    setName(name);
    setHealth(100);
    setPower(50);
    setArmour(50);
    setLevel(1);
    setXP(0);
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
int Animal::getLevel()
{
    return mLevel;
}
int Animal::getXP()
{
    return mXP;
}

//Setters
void Animal::setName(std::string name)
{
    mName = name;
}
void Animal::setHealth(int health)
{
    if (health >= 1 && health <= 100)
    {
        mHealth = health;
    }
    else if (health <= 0)
    {
        mHealth = 1;
        mLevel -= 1;
    }
}
void Animal::setPower(int power)
{
    if (power >= 1 && power <= 200)
    {
        mPower = power;
    }
}
void Animal::setArmour(int armour)
{
    if (armour >= 1 && armour <= 200)
    {
        mArmour = armour;
    }
}
void Animal::setLevel(int level)
{
    if (level >= 1 && level <= 100)
    {
        mLevel = level;
    }
}
void Animal::setXP(int xp)
{
    if (xp >= 0)
    {
        mXP = xp;
    }
    if (mXP >= 100)
    {
        std::cout << "Level Up!" << std::endl;
        setLevel(mLevel + 1);
        setXP(mXP - 100);
        setArmour(mArmour + 10);
        setPower(mPower + 10);
        setHealth(100);
    }
}

//Other functions
void Animal::FightOpponent(Animal* opponent)
{
    while (opponent->isAwake() && isAwake())
    {
        int hit = (mPower / opponent->getArmour()) + (rand() % 5 + 10);
        std::cout << mName << " hits for " << hit << std::endl;
        opponent->setHealth(opponent->getHealth() - hit);
        if (!opponent->isAwake())
        {
            int xp = opponent->getLevel() * 10;
            std::cout << std::endl << mName << " wins and gains " << xp << " experience!" << std::endl;
            setXP(mXP + xp);
            return;
        }
        hit = (opponent->getPower() / mArmour) + (rand() % 5 + 10);
        std::cout << opponent->getName() << " hits for " << hit << std::endl;
        setHealth(mHealth - hit);
        if (!isAwake())
        {
            std::cout << std::endl << "Oh no! " << mName << " has passed out and needs healing!" << std::endl;
        }
    }
}
bool Animal::isAwake()
{
    if (mHealth <= 20)
    {
        return false;
    }
    else
    {
        return true;
    }
}
void Animal::PrintStats()
{
    std::cout << "***********************" << std::endl;
    std::cout << "Name: " << getName() << std::endl;
    std::cout << "Level: " << getLevel() << std::endl;
    std::cout << "Health: " << getHealth() << std::endl;
    std::cout << "Power: " << getPower() << std::endl;
    std::cout << "Armour: " << getArmour() << std::endl;
    //std::cout << "XP to next level: " << 100 - (getXP()) << std::endl;
    std::cout << "***********************" << std::endl;
}