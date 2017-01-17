//Paulina Grey
//ITP 165, Fall 2015
//Homework 09 Header File
//pgrey@usc.edu

#include <fstream>
#include <string>

//Function: GetAnimalData
//Purpose: Opens a file and reads generic animal data and stores the data for later use into the parameters
//Parameters: string name of file to open, string to store animal name, int to store animal health
//			  int to store animal happiness, int to store animal hunger, int to store animal energy, 
//			  int to store animal age 
//Return: true if no errors, false if File Not Found error
bool GetAnimalData(std::string& fileName, std::string& name, int& health, int& happiness, int& hunger, int& energy, int& age)
{
	std::ifstream fin(fileName);
	if (fin.is_open())
	{
		fin >> health;
		fin >> happiness;
		fin >> hunger;
		fin >> energy;
		fin >> age;
		fin.ignore();
		std::getline(fin, name);
	}
	//ERROR: File Not Found
	else
	{
		return false;
	}

	//No errors
	return true;
}

//Function: SaveAnimalData
//Purpose: Open an output file to save Animal data to in correct format
//Parameters: string for file name to open, string name of animal, int health of animal, int happiness of animal
//			  int hunger of animal, int energy of animal, int age of animal 
//Return: true if no errors, false if any issues opening output file
bool SaveAnimalData(std::string& fileName, std::string& name, int health, int happiness, int hunger, int energy, int age)
{
	std::ofstream fout(fileName);
	if (fout.is_open())
	{
		fout << health << std::endl;
		fout << happiness << std::endl;
		fout << hunger << std::endl;
		fout << energy << std::endl;
		fout << age << std::endl;
		fout << name << std::endl;
	}
	else
	{
		return false;
	}
	//no errors
	return true;
}
