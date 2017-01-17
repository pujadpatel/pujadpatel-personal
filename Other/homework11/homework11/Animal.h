//Paulina Grey
//ITP 165, Fall 2015
//Homework 11
//pgrey@usc.edu

#pragma once

#include <string>

class Animal
{
private:
	std::string mName;
	int mHealth;
	int mPower;
	int mArmour;
	int mLevel;
	int mXP;
public:
	//Constructors
	Animal();
	Animal(std::string name, int health, int power, int armour, int level, int xp);
	Animal(std::string fileName);
	//Getters
	std::string getName();
	int getHealth();
	int getPower();
	int getArmour();
	int getLevel();
	int getXP();
	//Setters
	void setName(std::string name);
	void setHealth(int health);
	void setPower(int power);
	void setArmour(int armour);
	void setLevel(int level);
	void setXP(int xp);
	//Name: FightOpponent
	//Purpose:
	//Parameters: pointer to animal object to fight against
	//Return: nothing
	void FightOpponent(Animal* opponent);
	//Name: isAwake
	//Purpose: returns false when the animal has too low of health to fight more
	//Parameters: none
	//Return: true if health > 20, false is health <= 20
	bool isAwake();
	//Name: PrintStats
	//Purpose: Prints the current stats of Animal
	//Parameters: none
	//Return: none
	void PrintStats();
};	