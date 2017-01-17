//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 19
//  pujadpat@usc.edu

#pragma once

class Coordinate
{
private:
    double mx;
    double my;
public:
    Coordinate();
    Coordinate(double x, double y);
    Coordinate(double x);
    
    //getters
    double getX();
    double getY();
    
    //setters
    void setX(double x);
    void setY(double y);
    
    //other functions
    void print();
    
};


