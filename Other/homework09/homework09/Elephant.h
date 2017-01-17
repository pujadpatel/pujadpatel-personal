//  Puja Pattel
//  ITP 165, Fall 2015
//  Homework 9
//  pujadpat@usc.edu

#pragma once
#include <string>

class Elephant
{
private:
    int mhunger;
    int mhappiness;
    int mhealth;
    int menergy;
    int mage;
    std::string mname;
public:
    //default constructor
    Elephant();
    //non-default constructor
    Elephant(int happiness, int health, int energy, int hunger,int age, std::string name);
    
    //setters
    void sethunger(int hunger);
    void sethappiness (int happiness);
    void sethealth (int health);
    void setenergy (int energy);
    void setage (int age);
    void setname (std::string name);
    
    //getters
    int gethunger();
    int gethappiness();
    int gethealth();
    int getenergy();
    int getage();
    std::string getname();
    
    //other functions
    void Play();
    void Feed();
    void GiveMedicine();
    void Sleep();
};