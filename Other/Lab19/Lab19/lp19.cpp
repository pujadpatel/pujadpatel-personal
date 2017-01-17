//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 19
//  pujadpat@usc.edu


#include "Coordinate.h"
#include <iostream>
#include <cmath>

double calcDist(Coordinate& c1, Coordinate& c2)
{
    return std::sqrt(std::pow(c1.getX()-c2.getX(),2.0) + std::pow(c1.getY()-c2.getY(), 2.0));
}
int main()
{
    Coordinate* first = new Coordinate;
    Coordinate* second = new Coordinate;
    double input;
    
    std::cout << "Enter the first x: ";
    std::cin >> input;
    first->setX(input);
    std::cout << "Enter the first y: ";
    std::cin >> input;
    first->setY(input);
    
    std::cout << "The distance between ";
    first->print();
    std::cout <<" and ";
    second->print();
    std::cout << " is " <<calcDist(*first,*second) <<std::endl;
    
    delete first;
    delete second;
    first = nullptr;
    second = nullptr;
    
    return 0;
}
