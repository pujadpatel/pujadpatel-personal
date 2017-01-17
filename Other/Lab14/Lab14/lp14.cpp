//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 1
//  pujapdat@usc.edu


#include <iostream>
#include <cmath>

struct Coordinate
{
    double x;
    double y;
};

void printCoord (Coordinate& point)
{
    std::cout << "(" << point.x << "," << point.y << ")";
    
}

double calcDist (Coordinate& c1, Coordinate& c2)
{
    double retVal;
    retVal = std::sqrt(std::pow(c1.x-c2.x,2)+std::pow(c1.y-c2.y,2));
    return retVal;
}

int main()
{
    Coordinate first, second;
    
    std::cout << "Enter the 1st x: ";
    std::cin >> first.x;
    std::cout << "Enter the 1st y: ";
    std::cin >> first.y;
    
    std::cout << "Enter the 2nd x: ";
    std::cin >> second.x;
    std::cout << "Enter the 2nd y: ";
    std::cin >> second.y;
    
    std::cout << "Distance between";
    printCoord(first);
    std::cout << " and ";
    printCoord(second);
    std::cout << " is " <<calcDist(first,second) <<std::endl;
    
    return 0;
}
