// Puja Patel
// ITP 165, Fall 2015
// Homework 12
// pujadpat@usc.edu

#pragma once
#include "Animal.h"

class Elephant : public Animal
{
public:
    int mhunger;
    int mhappiness;
    int menergy;
    int mage;
public:
    //non-default constructor
    Elephant(std::string name);
    
    //setters
    void sethunger(int hunger);
    void sethappiness (int happiness);
    void setenergy (int energy);
    void setage (int age);
    
    //getters
    int gethunger();
    int gethappiness();
    int getenergy();
    int getage();
    
    //other functions
    void Play();
    void Feed();
    void GiveMedicine();
    void Sleep();
    void Load(std::string fileName);
    void Save(std::string fileName);
    void PrintStats();
};
