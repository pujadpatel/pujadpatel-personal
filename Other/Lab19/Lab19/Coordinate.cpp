//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 19
//  pujadpat@usc.edu

#include <iostream>
#include "Coordinate.h"

    Coordinate::Coordinate()
    {
        mx = 0;
        my = 0;
    }
    Coordinate::Coordinate(double x, double y)
    {
        setX(x);
        setY(y);
    }
    
    //getters
    double Coordinate::getX()
    {
        return mx;
    }

    double Coordinate::getY()
    {
        return my;
    }
    
    //setters
    void Coordinate::setX(double x)
    {
        mx=x;
    }

    void Coordinate::setY(double y)
    {
        my=y;
    }
    
    //other functions
    void Coordinate::print()
    {
        std::cout << "(" << mx << "," << my << ")";
    }
