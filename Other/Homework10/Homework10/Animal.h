//Paulina Grey
//ITP 165, Fall 2015
//Homework 10
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
public:
	/**********Constructors**********/
	//Default Constructor: will set private member variables to default values
	//mName: "Animal"
	//mHealth: 70
	//mPower: 60
	//mArmour: 50
	Animal();
	
	//Non-Default Constructor: will set private member variables via parameters
	//mName: name
	//mHealth: health
	//mPower: power
	//mArmour: armour
	Animal(std::string name, int health, int power, int armour);
	
	//Non-Default Constructor: will set private member variables from data in file
	//calls implemented Load(fileName) function
	Animal(std::string fileName);
	
	/**********Getters**********/
	std::string getName();
	int getHealth();
	int getPower();
	int getArmour();
	
	/**********Setters**********/
	void setName(std::string name); //no restrictions on name
	void setHealth(int health); //range between 0 and 100
	void setPower(int power); //range between 0 and 100
	void setArmour(int armour); //range between 0 and 100
	
	/**********Other functions**********/
	//Name: Load
	//Purpose: Opens file to read in animal data to temporary variables, CLOSES the file, 
	//		   then sets animal data with temp variable values - sets animal data to default values if file open failed
	//Parameters: string of file name to be opened
	//Return: none
	void Load(std::string fileName);
	
	//Name: Save
	//Purpose: Opens a file to write CURRENT animal data to, then CLOSES the file, does nothing if file open failed
	//Parameters: string of file name to be opened
	//Return: none
	void Save(std::string fileName);
};